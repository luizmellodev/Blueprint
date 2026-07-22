---
title: Persistence
summary: SwiftData, FavoritePOI, and the FavoritesRepository.
chapter: 7
status: done
---
# Persistence

Favorites are persisted with SwiftData while keeping the Domain layer clean.

## Separation

- **`POI`** — Domain entity, plain struct, no `@Model`
- **`FavoritePOI`** — SwiftData `@Model` in the Data layer
- **`FavoritesRepository`** — abstracts SwiftData from UseCases

```swift
@Model
final class FavoritePOI {
    var poiID: String
    var name: String
    // ...
}
```

The Domain never imports SwiftData. Mapping between `FavoritePOI` and `POI` happens inside the repository.
