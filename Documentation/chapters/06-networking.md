---
title: Networking
summary: NetworkClient, Geoapify API, DTOs, and caching.
chapter: 6
status: done
---
# Networking

The Data layer talks to Geoapify through a protocol-based network client.

## Layers

```
POIRepository → NetworkClient → URLSessionNetworkClient
                     ↓
              GeoapifyResponseDTO → GeoapifyMapper → POI
```

## Key decisions

- **Protocol in Domain/Networking** — `NetworkClient` has no URLSession dependency in callers
- **DTOs stay in Data** — API shapes never leak into Domain entities
- **Actor cache** — `POICacheService` protects file I/O with a 5-minute TTL

```swift
struct POIRepository: POIRepositoryProtocol {
    func fetchNearby(latitude: Double, longitude: Double, offset: Int) async throws -> PagedResult<POI> {
        // builds URL, calls client, maps DTOs
    }
}
```

API keys are injected via xcconfig → Info.plist, never hardcoded in source.
