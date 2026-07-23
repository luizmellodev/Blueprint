---
title: Repositories & Services
summary: How I hid Geoapify and SwiftData behind Repositories and Services.
order: 3
---
# Repositories & Services

*How I talked to APIs and device frameworks from the Data layer.*

The Data layer talks to Geoapify, CoreLocation, disk cache, SwiftData. I used two shapes: **Repositories** (give me domain objects) and **Services** (wrap a capability).

## Repository

A Repository answers: *give me `POI` (or similar), I do not care if it came from HTTP or disk.*

| Repository | Source |
|---|---|
| `POIRepository` | Geoapify + file cache |
| `PlaceDetailsRepository` | Geoapify details endpoint |
| `GeocodingRepository` | Geoapify geocoding |
| `FavoritesRepository` | SwiftData |

Each one has a **protocol** (what UseCases see) and a **class** (what Data implements).

```swift
protocol POIRepositoryProtocol {
  func fetchNearby(lat: Double, lon: Double, limit: Int, offset: Int) async throws -> [POI]
}

final class POIRepository: POIRepositoryProtocol {
  func fetchNearby(...) async throws -> [POI] {
    let data = try await client.data(for: request)
    let dto = try JSONDecoder().decode(GeoapifyResponseDTO.self, from: data)
    return dto.features.compactMap(GeoapifyMapper.map)
  }
}
```

`FetchNearbyPOIsUseCase` holds `POIRepositoryProtocol`. DI passes `POIRepository()` at runtime; the UseCase never imports that class.

Inside `POIRepository`: build URL, call `NetworkClient`, decode DTO, map to `POI`, maybe cache. UseCases do not see those steps.

### What I did

One repository per data source / API surface. Protocol at the boundary, DTO + mapper inside the class.

### Why (then)

I had duplicated URL-building instincts in ViewModels on past projects. Moving Geoapify shape into Repositories meant one place to fix when the API changed.

### What I'd reconsider

Three repositories repeat similar URL/request code. I would extract a `GeoapifyRequestBuilder` or endpoint enum before adding a fourth endpoint. See [Networking](/architecture/networking/).

## Service

A Service wraps infrastructure that is not "fetch this entity from source X."

| Service | Role |
|---|---|
| `LocationService` | CoreLocation permissions + coordinates |
| `POICacheService` | Disk cache actor (used inside `POIRepository`) |
| `FeatureFlagService` | Toggle map, favorites, filters |

`HomeViewModel` uses `LocationServiceProtocol` directly because current location is device infrastructure, not a Geoapify fetch.

### What I did

Services for cross-cutting capabilities. Cache stays internal to `POIRepository` instead of exposing a `CacheRepository`.

### Why (then)

Location did not fit "return `[POI]` from named source." Feature flags are toggles, not entities. Keeping cache inside the POI repository avoided an extra protocol for one consumer.

### What I'd reconsider

The line between Repository and Service is fuzzy. `FavoritesRepository` is CRUD-like; `LocationService` is not. On another app I might wrap location in a UseCase for symmetry. Here I was pragmatic.

## How I tell them apart (in this repo)

| Question | I used a… |
|---|---|
| UseCase returns domain entities from a named source (API, DB)? | Repository |
| Shared Apple framework behavior, no single entity? | Service |
| Helper only one repository needs? | Private to that repository (cache) |

Not a universal rule. A naming guide for Discover.

## DTOs stay in Data

Geoapify returns nested JSON (`GeoapifyResponseDTO`). Repositories decode and map to `POI`. Domain never imports `properties.name`.

## Could the ViewModel call Geoapify directly?

Yes, with `URLSession` in the View. I did that in early prototypes elsewhere. Here I wanted UseCase tests to mock `POIRepositoryProtocol` instead of stubbing HTTP in every ViewModel test.

## Could `POI` decode Geoapify JSON directly?

Yes, if `POI` were `Codable` against the API shape. I split DTO and entity to practice changing APIs without touching Domain. More files, clearer boundary.

## Read next

- [Networking](/architecture/networking/)
- [SwiftData](/architecture/swiftdata/)
