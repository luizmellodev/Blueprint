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

Discover persists favorite POIs. SwiftData requires `@Model` classes. Domain layer must stay framework-free.

## Problem

Making `POI` a `@Model` couples Domain to SwiftData. Swapping persistence backends requires rewriting business entities.

## Alternatives

1. **@Model on POI:** simple but violates clean architecture
2. **UserDefaults:** doesn't scale for rich favorites
3. **Separate FavoritePOI + Repository mapping:** clean boundary

## Decision

`POI` stays a Domain struct. `FavoritePOI` is a Data-layer `@Model`. `FavoritesRepository` maps between them.

## Consequences

**Positive:**
- Domain has zero SwiftData imports
- Persistence backend swappable
- Teaches correct layer separation

**Negative:**
- Mapping boilerplate
- Favorite is a snapshot, not live API data

## References

- [SwiftData](/architecture/swiftdata/)
- `blueprint/Data/Persistence/FavoritePOI.swift`
