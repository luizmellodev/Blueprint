---
title: Networking
summary: NetworkClient, Geoapify API, DTOs, mappers, and the Repository pattern.
order: 5
---
# Networking

## The problem

API response shapes change. URL construction, decoding, and mapping must not leak into ViewModels or Domain entities.

## Why protocol-based client + DTOs

Repositories depend on `NetworkClient` protocol. DTOs decode JSON; mappers produce Domain `POI`. ViewModels never see Geoapify field names.

## Alternatives considered

| Approach | Verdict |
|---|---|
| URLSession in ViewModels | ❌ Untestable, mixed concerns |
| Codable on Domain entities | ❌ API shapes pollute Domain |
| **Repository + DTO + Mapper** | ✅ Chosen |

## Trade-offs

- **Pro:** Domain stays clean; API changes isolated to Data layer
- **Pro:** Mock `NetworkClient` in tests
- **Con:** Boilerplate (DTOs, mappers) for each endpoint

## How Blueprint implements it

```
ViewModel → UseCase → Repository → NetworkClient → Geoapify
                         ↓
                   DTO → Mapper → POI
```

Geoapify free tier: 3,000 req/day. POIs support pagination, geocoding, and place details.

## Related code

- `Packages/Networking/`
- `blueprint/Data/Repositories/POIRepository.swift`
- `blueprint/Data/DTO/GeoapifyMapper.swift`
- `blueprint/Domain/UseCases/FetchNearbyPOIsUseCase.swift`

## Further reading

- [Repository Pattern](/concepts/repository-pattern/)
- [Use Cases](/concepts/use-cases/)
- [Caching](/concepts/caching/)
- [API Key Setup](/guides/api-key-setup/)
