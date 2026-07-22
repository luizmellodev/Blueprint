---
title: Caching
summary: POICacheService — file-backed cache with 5-minute TTL.
order: 5
---
# Caching

## The problem

Every navigation back to Home would refetch POIs from Geoapify — wasting API quota and adding latency.

## Why file-backed cache with TTL

`POICacheService` writes JSON to `CachesDirectory`. Entries expire after 300 seconds (5 minutes).

## Why @MainActor instead of actor

Project uses `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`. A standalone `actor` would require explicit `nonisolated` on helpers. Cache I/O is fast and only called from main-actor ViewModels.

## Why 5 minutes

- POI data is not real-time
- Geoapify free tier: 3,000 requests/day
- Short enough for reasonable freshness; long enough for back-navigation speed

## Related code

- `blueprint/Data/Cache/POICacheService.swift`

## Further reading

- [Networking](/architecture/networking/)
- [Performance](/architecture/performance/)
