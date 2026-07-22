---
title: Persistence
summary: SwiftData in the Data layer — FavoritePOI separate from Domain POI.
order: 6
---
# Persistence

## The problem

Favorites must survive app restarts. SwiftData's `@Model` macro transforms classes — it cannot live in the Domain layer without coupling business logic to a persistence framework.

## Why separate FavoritePOI from POI

Domain `POI` is a plain struct. `FavoritePOI` is a `@Model` class in Data. Mapping happens inside `FavoritesRepository`.

## Alternatives considered

| Approach | Verdict |
|---|---|
| `@Model` on Domain POI | ❌ Domain depends on SwiftData |
| UserDefaults for favorites | ❌ Doesn't scale |
| **Separate model + Repository** | ✅ Chosen |

## Trade-offs

- **Pro:** Domain swap-friendly (Core Data, CloudKit later)
- **Pro:** Repository abstracts `ModelContext` from ViewModels
- **Con:** Mapping code between FavoritePOI ↔ POI

## How Blueprint implements it

```swift
@Model
final class FavoritePOI {
    var poiID: String
    var name: String
    // snapshot fields...
}
```

`FavoritesUseCase` → `FavoritesRepository` → SwiftData. ViewModels never call `modelContext` directly.

## Related code

- `blueprint/Data/Persistence/FavoritePOI.swift`
- `blueprint/Data/Persistence/FavoritesRepository.swift`
- `blueprint/Domain/UseCases/FavoritesUseCase.swift`

## Further reading

- [ADR 0005: SwiftData Domain Separation](/decisions/0005-swiftdata-domain-separation/)
- [Repository Pattern](/concepts/repository-pattern/)
