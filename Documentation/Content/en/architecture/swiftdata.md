---
title: SwiftData
summary: How I persisted favorites without making POI a SwiftData model.
order: 5
---
# SwiftData

*How I saved favorites on device while keeping Domain as plain structs.*

**Favorites** persist with **SwiftData**. Places from Geoapify do not; they are fetched on demand and cached briefly on disk inside `POIRepository`.

## Why SwiftData here?

Favorites need:

- Storage across app launches
- Simple queries (is this id saved? list all)
- No backend to sync with (study app scope)

I picked SwiftData over Core Data for less boilerplate at this size. Apple-native, `@Model`, `ModelContext`.

### What I did

`FavoritePOI` (`@Model`) in Data. Domain `POI` stays a struct. `FavoritesRepository` maps both ways.

### Why (then)

I wanted to practice "persistence model ≠ domain model" the same way DTOs differ from entities for Geoapify.

### What I'd reconsider

If favorites were the only representation of a place and never came from an API, I might use `@Model` as the single source of truth and skip the mapper. Here both tabs show `POI`, so the struct stayed central.

## Domain vs persistence model

Domain: `POI` (struct, value type, no framework).

Data: `FavoritePOI` (`@Model` class).

```swift
@Model
final class FavoritePOI {
  var id: String
  var name: String
  // ...
}
```

`FavoritesRepository`:

- `add(_ poi: POI)` → insert `FavoritePOI(from: poi)`
- `fetchAll()` → map models back to `[POI]`

ViewModels call `FavoritesUseCase`, which calls `FavoritesRepositoryProtocol`. SwiftData never appears in Presentation.

## ModelContext wiring

`PersistenceDependencies` creates a `ModelContainer` for `FavoritePOI.self` and passes `ModelContext` into `FavoritesRepository` and `FavoritesUseCase`. Once, in DI, not in Views.

## Favorites tab flow

1. `FavoritesViewModel` → `FavoritesUseCase.fetchAll()`
2. UseCase → repository
3. Repository fetches `FavoritePOI` rows, returns `[POI]`
4. ViewModel updates UI state
5. Swipe to delete → same chain

Detail uses the same UseCase for `isFavorite` and the heart button.

## Could `POI` be `@Model` directly?

Yes. Simpler file count, one type for list and favorites. Downside: Domain would depend on SwiftData, and API-sourced fields (live Geoapify data) mix with persisted rows. I kept them separate to learn the mapper; I might merge on a production app if the domain model matched persistence 1:1.

## Could I use UserDefaults or a JSON file?

Yes for a handful of favorites. SwiftData felt worth learning for queries and relationships if the app grew (folders, notes, sync later).

## Read next

- [Repositories & Services](/architecture/repositories-and-services/)
- [Domain](/architecture/domain/)
