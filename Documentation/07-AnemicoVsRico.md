# Capítulo 7: Modelos Anêmicos vs Ricos

## O que são modelos anêmicos?

**Modelos anêmicos** são estruturas de dados que contêm apenas propriedades — sem comportamento. Em Swift, isso geralmente aparece como uma `struct` ou `class` com `let`/`var`, mas nenhum método de negócio.

```swift
struct POI {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let city: String?
}
```

Toda a lógica relacionada a POIs — validação, formatação, cálculos — vive em outros lugares: ViewModels, Repositories, Use Cases ou funções globais.

### Características

- ✅ Simples de entender
- ✅ Separação clara de responsabilidades
- ❌ Sem proteção de invariantes
- ❌ Lógica de domínio espalha-se por múltiplas camadas
- ❌ Duplicação de código
- ❌ Difícil de testar regras isoladamente

---

## O que são modelos ricos?

**Modelos ricos** encapsulam dados **e** comportamento. Eles protegem invariantes, fornecem métodos convenientes e centralizam regras que pertencem naturalmente ao conceito do domínio.

```swift
struct POI {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let city: String?
    
    init(id: String, name: String, latitude: Double, longitude: Double) throws {
        guard !id.isEmpty else { throw ValidationError.emptyID }
        guard !name.isEmpty else { throw ValidationError.emptyName }
        guard (-90...90).contains(latitude) else { throw ValidationError.invalidLatitude }
        guard (-180...180).contains(longitude) else { throw ValidationError.invalidLongitude }
        
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        let poiLocation = CLLocation(latitude: latitude, longitude: longitude)
        return location.distance(from: poiLocation)
    }
}
```

### Características

- ✅ Invariantes garantidos
- ✅ Código auto-documentado
- ✅ Reutilização de comportamento
- ✅ Facilita testes unitários
- ❌ Pode acoplar a frameworks
- ❌ Pode violar SRP se crescer demais
- ❌ Mais complexo para iniciantes

---

## A decisão do Blueprint: Modelos Semi-Ricos

O Blueprint começou com **modelos anêmicos** (Capítulos 1-6):

```swift
struct POI: Hashable, Sendable, Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    // ...
}
```

Isso funcionou bem inicialmente, mas revelou problemas conforme a aplicação cresceu:

### Problema 1: Vazamento de Lógica de Domínio

**HomeViewModel continha:**

```swift
private func filtered(_ pois: [POI]) -> [POI] {
    guard !searchQuery.isEmpty else { return pois }
    return pois.filter {
        $0.name.localizedCaseInsensitiveContains(searchQuery) ||
        ($0.city ?? "").localizedCaseInsensitiveContains(searchQuery)
    }
}

private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
    // ...
    guard status == .authorized else {
        return (latitude: -23.5505, longitude: -46.6333) // São Paulo hardcoded
    }
    // ...
}
```

**Problemas:**
- Filtro de POI está na camada de apresentação
- Coordenadas de fallback hardcoded no ViewModel
- Lógica duplicada se outro ViewModel precisar filtrar POIs

### Problema 2: Sem Proteção de Invariantes

Nada impedia criar POIs inválidos:

```swift
let invalid = POI(
    id: "",           // ❌ vazio
    name: "",         // ❌ vazio
    latitude: 200,    // ❌ fora do range
    longitude: -300   // ❌ fora do range
)
```

A validação estava implícita no `GeoapifyMapper`, mas nada protegia contra bugs no código interno.

### Problema 3: Comportamentos Úteis Ausentes

Para converter POI para `CLLocationCoordinate2D`, precisávamos fazer isso manualmente em múltiplos lugares:

```swift
let coord = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
```

Para calcular distância:

```swift
let poiLocation = CLLocation(latitude: poi.latitude, longitude: poi.longitude)
let distance = userLocation.distance(from: poiLocation)
```

Código repetitivo e propenso a erro.

---

## A solução: Semi-Ricos

Adicionamos **comportamento intrínseco** sem transformar POI em um "God Object":

### 1. Invariantes com `let` + `init` validado

```swift
struct POI: Hashable, Sendable, Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(
        id: String,
        name: String,
        latitude: Double,
        longitude: Double,
        // ...
    ) throws {
        guard !id.isEmpty else { throw ValidationError.emptyID }
        guard !name.isEmpty else { throw ValidationError.emptyName }
        guard (-90...90).contains(latitude) else { throw ValidationError.invalidLatitude }
        guard (-180...180).contains(longitude) else { throw ValidationError.invalidLongitude }
        
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        // ...
    }
}
```

**Por que total imutabilidade (`let`)?**
- Value semantics do Swift: uma vez criado, o POI não muda
- `Codable` funciona perfeitamente com `let` (synthesized init)
- Mais simples de raciocinar: POI é criado válido e permanece válido
- Thread-safe por design: `Sendable` conformance é trivial

**Por que `throws`?**
- Falha rápida e clara ao tentar criar POI inválido
- Testes podem verificar que validação funciona
- Compatível com `Codable`: se JSON vier inválido, falha na decodificação

### 2. Computed Properties Convenientes

**No arquivo principal `POI.swift`:**

```swift
extension POI {
    var formattedAddress: String {
        [address, city, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    var displayCategories: String {
        categories.map { $0.rawValue.capitalized }.joined(separator: ", ")
    }
}
```

**No arquivo `POI+Location.swift`:**

```swift
extension POI {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var isValidCoordinate: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
}
```

**Quando adicionar computed property:**
- Deriva de dados existentes no próprio POI
- É uma transformação ou formatação dos dados intrínsecos
- Não depende de estado externo

**Organização:**
- Properties gerais ficam em `POI.swift`
- Properties específicas de localização em `POI+Location.swift`

### 3. Comportamentos Intrínsecos

**Arquivo `POI.swift`** — Core + computed properties básicas:

```swift
extension POI {
    var formattedAddress: String {
        [address, city, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    var displayCategories: String {
        categories.map { $0.rawValue.capitalized }.joined(separator: ", ")
    }
}
```

**Arquivo `POI+Location.swift`** — Comportamento de localização:

```swift
import CoreLocation

extension POI {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var isValidCoordinate: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        let poiLocation = CLLocation(latitude: latitude, longitude: longitude)
        return location.distance(from: poiLocation)
    }
}
```

**Arquivo `POI+Filtering.swift`** — Comportamento de busca:

```swift
extension POI {
    func matches(query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let lowercased = query.lowercased()
        return name.lowercased().contains(lowercased) ||
               city?.lowercased().contains(lowercased) == true
    }
}

extension Array where Element == POI {
    func filtered(by query: String) -> [POI] {
        guard !query.isEmpty else { return self }
        return filter { $0.matches(query: query) }
    }
}
```

**Por que em extensions separadas?**
- **Organização:** comportamentos relacionados ficam juntos
- **Import isolation:** CoreLocation só precisa ser importado em POI+Location
- **Navegação:** fácil encontrar código de localização vs busca
- **Escalabilidade:** podemos adicionar POI+MapKit, POI+Analytics, etc. sem poluir o arquivo principal

### 4. Movendo Lógica de Domínio do ViewModel

Arquivo `LocationDefaults.swift`:

```swift
import CoreLocation

enum LocationDefaults {
    static let saoPaulo = CLLocationCoordinate2D(
        latitude: -23.5505,
        longitude: -46.6333
    )
}
```

**HomeViewModel — Antes:**

```swift
private func filtered(_ pois: [POI]) -> [POI] {
    guard !searchQuery.isEmpty else { return pois }
    return pois.filter {
        $0.name.localizedCaseInsensitiveContains(searchQuery) ||
        ($0.city ?? "").localizedCaseInsensitiveContains(searchQuery)
    }
}

private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
    // ...
    guard status == .authorized else {
        return (latitude: -23.5505, longitude: -46.6333)
    }
    // ...
}
```

**HomeViewModel — Depois:**

```swift
private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
    // ...
    guard status == .authorized else {
        let fallback = LocationDefaults.saoPaulo
        return (latitude: fallback.latitude, longitude: fallback.longitude)
    }
    // ...
}

// Filtro saiu completamente — agora usamos:
visiblePOIs = allPOIs.filtered(by: searchQuery)
```

**Benefícios:**
- ViewModel mais limpo e focado em orquestração de UI
- Lógica de filtro centralizada no Domain
- Reutilizável em qualquer lugar (FavoritesViewModel, testes, etc.)
- LocationDefaults documenta claramente que São Paulo é o fallback padrão

---

## Quando adicionar comportamento ao modelo?

Use este guia de decisão:

### ✅ Adicionar quando:

1. **Invariantes de negócio**
   - Coordenadas válidas (`-90...90`, `-180...180`)
   - IDs não-vazios
   - Relacionamentos consistentes entre campos

2. **Comportamentos intrínsecos**
   - Cálculo de distância (faz parte da natureza de um POI)
   - Formatação de endereço (apresentação dos próprios dados)
   - Matching/filtering (operação sobre os próprios campos)

3. **Computed properties derivadas**
   - `coordinate` (conversão dos campos latitude/longitude)
   - `isValid` (validação de estado interno)
   - `displayName` (regra de apresentação)

### ❌ NÃO adicionar quando:

1. **Orquestra múltiplos serviços**
   - Toggle de favorito → depende de `FavoritesRepository`
   - Busca paginada → depende de API + cache
   - **Solução:** Use Case

2. **É política de aplicação**
   - Page size de 20 → configuração de UX
   - Debounce de 300ms → decisão de UI
   - Número de tentativas de retry → infraestrutura
   - **Solução:** ViewModel ou configuração global

3. **Depende de estado externo**
   - "Este POI é favorito?" → precisa consultar banco
   - "Está próximo?" → precisa da localização atual do usuário
   - **Solução:** Use Case ou Repository

---

## Arquitetura final

```
View
  ↓
ViewModel
  • Orquestra UI (loading, error, success)
  • Debounce e cancelamento de tasks
  • Decisões de UX (page size, timing)
  ↓
UseCase
  • Orquestra múltiplos repositories/services
  • Regras de negócio complexas
  • Fluxos que dependem de estado externo
  ↓
Repository
  • Acesso a dados (API, cache, banco)
  • Mapeamento DTO → Domain
  ↓
Domain Entity
  • Invariantes (validação no init)
  • Comportamento intrínseco (distance, matches)
  • Computed properties (coordinate, formattedAddress)
```

Cada camada tem responsabilidade clara. O domínio fica **rico o suficiente** para proteger regras, mas **magro o suficiente** para não virar God Object.

---

## Impacto no código

### Arquivos modificados:
- `blueprint/Domain/Entities/POI.swift`
- `blueprint/Data/DTO/GeoapifyMapper.swift`
- `blueprint/Presentation/Views/Home/HomeViewModel.swift`
- `blueprintTests/Helpers/POI+Mock.swift`

### Arquivos criados:
- `blueprint/Domain/Entities/ValidationError.swift` — Enum com casos de validação (emptyID, emptyName, invalidLatitude, invalidLongitude)
- `blueprint/Domain/Entities/LocationDefaults.swift` — Coordenada de fallback (São Paulo)
- `blueprint/Domain/Entities/POI+Location.swift` — Extension com `coordinate`, `isValidCoordinate`, `distance(from:)`
- `blueprint/Domain/Entities/POI+Filtering.swift` — Extension com `matches(query:)` e `Array.filtered(by:)`
- `blueprintTests/Domain/POIValidationTests.swift` — 9 testes de validação do init
- `blueprintTests/Domain/POIBehaviorTests.swift` — 18 testes de comportamento (computed properties, métodos, array filtering)

### Testes adicionados:
- **POIValidationTests**: 9 testes verificando validação de ID, name, latitude, longitude
- **POIBehaviorTests**: 18 testes verificando computed properties, métodos de distância, filtro e array extensions

---

## Trade-offs e lições

### O que funcionou bem:

1. **Validação no `init`**
   - Impossível criar POI inválido
   - Falha rápida e clara
   - Testes documentam invariantes

2. **Computed properties**
   - `coordinate` eliminou duplicação em múltiplos lugares
   - `formattedAddress` centraliza regra de formatação
   - Código mais legível: `poi.coordinate` vs `CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)`

3. **Extensions por comportamento**
   - `POI+Location` agrupa lógica de localização
   - `POI+Filtering` agrupa lógica de busca
   - Facilita navegação e manutenção

4. **Lógica saiu do ViewModel**
   - HomeViewModel ficou 10 linhas mais curto
   - Filtro reutilizável em qualquer lugar
   - Fallback de São Paulo documentado em `LocationDefaults`

### O que evitamos:

1. **Não transformar POI em God Object**
   - POI não sabe nada sobre favoritos, cache, API
   - Comportamentos são intrínsecos ao conceito
   - Dependencies stay in outer layers

2. **Não acoplar a múltiplos frameworks**
   - `POI+Location` depende de CoreLocation, mas está isolado
   - O core do POI (id, name, coordinates) continua framework-free
   - Poderíamos criar `POI+MapKit` separado se necessário

3. **Não violar camadas**
   - POI não chama Repositories
   - POI não acessa UserDefaults ou banco de dados
   - Estado externo continua gerenciado por Use Cases

---

## Conclusão

Blueprint adotou **modelos semi-ricos**:

- ✅ Invariantes protegidos (validação no `init`)
- ✅ Computed properties úteis (`coordinate`, `formattedAddress`)
- ✅ Comportamentos intrínsecos (`distance`, `matches`)
- ❌ Não orquestra múltiplos serviços
- ❌ Não depende de estado externo

Isso mantém o código **didático** (ensina onde colocar regras), **limpo** (ViewModels mais focados) e **testável** (regras isoladas em testes unitários) — sem transformar entidades em God Objects.

**Regra de ouro:** Se a regra é sobre o próprio POI (suas coordenadas, seu nome, seu endereço), coloque no POI. Se depende de algo externo (banco, API, localização atual do usuário), coloque em Use Case ou Repository.
