# Blueprint — CLAUDE.md

## O que é esse projeto

**Blueprint** é uma referência pública de arquitetura moderna em SwiftUI. O app de exemplo se chama **Discover** e usa POIs (Points of Interest) via Geoapify API. Cada decisão técnica existe para ensinar — nada entra sem justificativa didática.

## Regras obrigatórias

### Git
- **Nunca** rodar `git commit` ou `git push` — apenas fornecer o comando para o usuário rodar
- Um commit por mudança lógica (não acumular tudo em um commit gigante)

### Arquivos Swift
- Todo arquivo Swift começa com o header padrão do Xcode:
```swift
//
//  NomeDoArquivo.swift
//  blueprint
//
//  Created by Luiz Mello on DD/MM/YY.
//
```

### Xcode
- Nunca pedir para o usuário criar grupos, mover arquivos ou deletar via terminal — essas ações são feitas no Xcode
- Quando um arquivo novo precisar ser adicionado a um target, informar o usuário para fazer no Xcode

### Código
- Sem comentários explicando O QUE o código faz — só `TODO:` para documentação futura
- Formato dos TODOs: `// TODO: Explicar porque X` (viram `.md` depois que o capítulo fecha)
- Sem abstrações além do necessário para a tarefa atual

## Arquitetura

```
App Target (blueprint)
├── App/                    # @main, entry point
├── Navigation/             # AppRoute, AppRouter, RouterProtocol, AppRouterView
├── DI/
│   ├── DIContainer         # Assembler raiz (@MainActor)
│   ├── Core/               # NetworkDependencies, POIDependencies, LocationDependencies, PersistenceDependencies
│   └── Factories/          # HomeFactory, DetailFactory
├── Domain/
│   ├── Entities/           # POI, AppError, PagedResult (sem dependências externas)
│   └── Networking/         # NetworkClient protocol + URLSessionNetworkClient
├── Data/
│   ├── DTO/                # GeoapifyDTOs + GeoapifyMapper
│   ├── Cache/              # POICacheService (actor, TTL 5min)
│   ├── Location/           # LocationServiceProtocol, LocationService
│   ├── Persistence/        # FavoritePOI (@Model), FavoritesRepository, FavoritesUseCase
│   └── Repositories/       # POIRepository, FetchNearbyPOIsUseCase
└── Presentation/
    └── Views/
        ├── Home/           # HomeView, HomeViewModel, HomeUIState
        └── Detail/         # DetailView, DetailViewModel, DetailUIState

Packages/
└── DesignSystem/           # DSSpacing, DSTypography, DSRadius (tokens públicos)

Documentation/              # .md por capítulo (escrito após fechar o capítulo)
```

## Padrões

| Padrão | Decisão |
|---|---|
| State management | `@Observable` (iOS 17+), não `ObservableObject` |
| Navigation | `NavigationStack` + `AppRoute` enum + `RouterProtocol` |
| DI | DIContainer + Factories, sem framework externo |
| UseCase | `struct` conformando protocolo `Sendable` |
| Cache | `actor` para proteção contra data races |
| Persistence | SwiftData — `@Model` fica na camada Data, nunca no Domain |
| Testes | Swift Testing (`@Test`, `#expect`), mocks via protocolo |

## Segurança

- `blueprint/Secrets.swift` está no `.gitignore` e **nunca** deve ser commitado
- Contém: `enum Secrets { static let geoapifyAPIKey = "..." }`

## Roadmap

- **Semana 1** ✅ Projeto → Packages → Navigation → DI
- **Semana 2** ✅ Networking → API → Cache → Swift Testing
- **Semana 3** 🔄 Persistence → Feature Flags → Accessibility
- **Semana 4** Location Service ✅ → SwiftData ✅ → Feature Flags → Accessibility
- **Semana 4** Website → Diagramas → CI robusto → Deploy

## Packages externos

Nenhum (além de Firebase no projeto template de referência — não usamos aqui).
