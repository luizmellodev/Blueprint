---
title: Domain
summary: How I kept entities and UseCases free of frameworks.
order: 2
---
# Domain

*How I defined what Discover means, without SwiftUI or Geoapify types.*

**Domain** is the vocabulary and rules of the app, written in plain Swift. In this repo: no SwiftUI, no SwiftData, no Geoapify DTOs.

Presentation is what the user sees. Data is where bytes come from. Domain is what the app talks about.

## Entities

Structs for app concepts:

| Entity | Meaning |
|---|---|
| `POI` | A place in a list (name, category, coordinates, id) |
| `PlaceDetails` | Extra fields (phone, website, hours) |
| `GeocodingResult` | A city the user searched for |
| `PagedResult<T>` | Items + `hasMore` for pagination |
| `AppError` | Failures the UI can show |

`POI` is not an `@Model` class and not `Codable` against Geoapify JSON.

### What I did

Plain structs in `Domain/Entities/`. Persistence and API shapes live elsewhere.

### Why (then)

When Geoapify renamed a field, I wanted to edit DTOs and mappers, not every screen. Keeping `POI` framework-free made that plausible.

### What I'd reconsider

For favorites-only data with no API mirror, some teams make the SwiftData model the domain type. I split them here to practice the mapper pattern; on a tiny app that might be overkill.

## Use Cases

One Use Case = one application operation: fetch nearby POIs, toggle favorite, search city.

```swift
struct FetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol {
  let repository: POIRepositoryProtocol

  func execute(lat: Double, lon: Double, limit: Int, offset: Int = 0) async throws -> PagedResult<POI> {
    let pois = try await repository.fetchNearby(lat: lat, lon: lon, limit: limit, offset: offset)
    return PagedResult(items: pois, hasMore: pois.count == limit)
  }
}
```

ViewModels call UseCases. UseCases call repository protocols. They do not build URLs or touch `ModelContext`.

| Use Case | Protocol it uses |
|---|---|
| `FetchNearbyPOIsUseCase` | `POIRepositoryProtocol` |
| `FetchPlaceDetailsUseCase` | `PlaceDetailsRepositoryProtocol` |
| `SearchLocationUseCase` | `GeocodingRepositoryProtocol` |
| `FavoritesUseCase` | `FavoritesRepositoryProtocol` |

### What I did

Thin UseCases: mostly delegate to a repository, sometimes wrap results (`PagedResult`).

### Why (then)

I wanted to test pagination rules without SwiftUI. Favorites and Home could share the same fetch contract. ViewModels stayed focused on UI state.

### What I'd reconsider

Some UseCases are one-liners today. I might inline them into ViewModels until a second caller appears, or merge related operations. The layer is useful when it earns its file.

## Call chain

```
HomeView → HomeViewModel → FetchNearbyPOIsUseCase → POIRepositoryProtocol
```

Only the repository implementation knows about HTTP or cache files.

## Could the ViewModel call the Repository directly?

Yes. Many apps do. I inserted UseCases because I was learning the Clean Architecture seam: ViewModel → application logic → data access. For Discover's size, skipping UseCases and calling `POIRepositoryProtocol` from the ViewModel would still be readable.

## Could repository protocols live in Data instead of Domain?

Also yes. I put protocols next to UseCases so Domain defines what it needs from the outside (`fetchNearby` → `[POI]`) without importing Data. Some codebases invert that. Both work; I picked "Domain owns the port."

## Read next

- [Repositories & Services](/architecture/repositories-and-services/)
- [MVVM](/architecture/mvvm/)
