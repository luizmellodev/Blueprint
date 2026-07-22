---
title: "0005: SwiftData Separate from Domain"
summary: FavoritePOI @Model stays in Data layer; Domain POI remains a struct.
status: accepted
date: 2026-04-01
order: 5
---
# 0005: SwiftData Separate from Domain

## Status

Accepted

## Context

Favorites must persist across launches. SwiftData is the persistence framework chosen for iOS 17 teaching value. Domain layer must remain import-clean.

## Problem

Applying `@Model` to `POI` would couple business entities to Apple persistence APIs and make Domain untestable without SwiftData.

## Alternatives

1. **@Model on POI:** fewer types, wrong layer boundary
2. **UserDefaults:** too weak for queries and growth
3. **FavoritePOI + FavoritesRepository mapping:** explicit boundary

## Decision

Domain `POI` stays a struct. `FavoritePOI` is a Data-layer `@Model`. `FavoritesRepository` maps both ways. `FavoritesUseCase` is the Presentation entry point.

## What worked

- Domain files have zero SwiftData imports (easy to verify in reviews).
- Favorite snapshot model survives API changes to live `POI` fields.
- Toggle favorite from Detail is a clear UseCase → Repository story.

## What hurt

- Duplicate fields between `POI` and `FavoritePOI` (mapping boilerplate).
- `FavoritesRepository` is `@MainActor` because `ModelContext` is used on main thread.
- **No integration tests yet** for SwiftData (noted gap in [Testing](/architecture/testing/)).

## What we changed later

- Nothing in the persistence model. Planned: in-memory `ModelContainer` tests ([Future Directions](/guides/future-directions/)).
- Initial prototype stored favorite IDs in UserDefaults; migrated to SwiftData in chapter 7 (intentional refactor for teaching persistence properly).

## References

- [SwiftData](/architecture/swiftdata/)
- `blueprint/Data/Persistence/FavoritePOI.swift`
