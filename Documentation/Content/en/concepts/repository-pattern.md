---
title: Repository Pattern
summary: Abstract data access behind protocols — network, cache, and persistence.
order: 2
---
# Repository Pattern

## The problem

ViewModels that call URLSession or `ModelContext` directly cannot be tested and know too much about data sources.

## Why Repository

A protocol per data concern hides implementation. ViewModels and UseCases depend on `POIRepositoryProtocol`, not Geoapify URLs or SwiftData.

## In Blueprint

| Repository | Responsibility |
|---|---|
| `POIRepository` | Nearby POIs from Geoapify |
| `PlaceDetailsRepository` | Place details endpoint |
| `GeocodingRepository` | Location search |
| `FavoritesRepository` | SwiftData favorites |

## Rule

Presentation → UseCase → Repository → (Network / Cache / SwiftData)

Never skip layers.

## Related code

- `blueprint/Data/Repositories/`

## Further reading

- [Networking](/architecture/networking/)
- [Persistence](/architecture/persistence/)
