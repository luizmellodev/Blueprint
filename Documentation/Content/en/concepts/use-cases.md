---
title: Use Cases
summary: Stateless structs bridging ViewModels and Repositories.
order: 3
---
# Use Cases

## The problem

ViewModels accumulate business logic — pagination rules, mapping, cache policies — and become untestable god objects.

## Why Use Cases as structs

Each UseCase does one thing. Stateless struct = value semantics, `Sendable`, no hidden mutable state.

```swift
struct FetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol {
    let repository: POIRepositoryProtocol

    func execute(lat: Double, lon: Double, limit: Int, offset: Int) async throws -> PagedResult<POI> {
        let pois = try await repository.fetchNearby(...)
        return PagedResult(items: pois, hasMore: pois.count == limit)
    }
}
```

## Why struct, not class

No reference counting overhead. Cannot accidentally hold UI state. Thread-safe by default when Sendable.

## Related code

- `blueprint/Domain/UseCases/`

## Further reading

- [Dependency Injection](/architecture/dependency-injection/)
