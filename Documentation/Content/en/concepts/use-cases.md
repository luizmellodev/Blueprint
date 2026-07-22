---
title: Use Cases
summary: Stateless structs between ViewModels and Repositories. One operation per type.
order: 1
---
# Why Use Cases?

Use Cases are the **Domain entry point** for application operations. ViewModels call them; Use Cases call repository protocols.

## What problem does this solve?

Without Use Cases, ViewModels orchestrate repositories directly and duplicate rules (pagination, mapping policy) across screens.

Use Cases keep **one operation per type**, easy to name and test.

## Why this solution?

Blueprint Use Cases are `struct` types (mostly) with protocol pairs:

| Use Case | Protocol | Calls |
|---|---|---|
| `FetchNearbyPOIsUseCase` | `FetchNearbyPOIsUseCaseProtocol` | `POIRepositoryProtocol` |
| `FetchPlaceDetailsUseCase` | `FetchPlaceDetailsUseCaseProtocol` | `PlaceDetailsRepositoryProtocol` |
| `SearchLocationUseCase` | `SearchLocationUseCaseProtocol` | `GeocodingRepositoryProtocol` |
| `FavoritesUseCase` | `FavoritesUseCaseProtocol` | `FavoritesRepositoryProtocol` |

`FetchNearbyPOIsUseCase` wraps results in `PagedResult<POI>` for pagination metadata.

## Alternatives

| Approach | Verdict |
|---|---|
| ViewModel → Repository | Rejected: skips Domain layer |
| Interactor god class | Rejected: mixed operations |
| **One struct per operation** | Chosen |

## Trade-offs

- **Pro:** Tests target small units (`FetchNearbyPOIsUseCaseTests`)
- **Pro:** `Sendable` protocols where applicable
- **Con:** Extra file pair per operation
- **Con:** Thin pass-through when logic is minimal (acceptable for clarity)

## How Blueprint implements it

```swift
struct FetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol {
    private let repository: POIRepositoryProtocol
    func execute(lat:lon:limit:offset:) async throws -> PagedResult<POI> { ... }
}
```

Wired in `POIDependencies` and `PersistenceDependencies`, injected into factories.

```mermaid
flowchart LR
  VM[ViewModel]
  UC[UseCase struct]
  RP[Repository protocol]
  VM --> UC --> RP
```

## Related code

- `blueprint/Domain/UseCases/`
- `blueprint/DI/Core/POIDependencies.swift`
- `blueprintTests/FetchNearbyPOIsUseCaseTests.swift`

## Further reading

- [MVVM](/architecture/mvvm/)
- [Repository Pattern](/architecture/repository/)
- [Dependency Injection](/architecture/dependency-injection/)
