---
title: Modularization
summary: What I extracted into Swift Packages and what stayed in the app target.
order: 8
---
# Modularization

*What I pulled into Packages, and what I left in one target on purpose.*

Part of Blueprint lives in local Swift Packages under `Packages/`. The rest stays in the **blueprint** app target.

| Package | Exports | Imports |
|---|---|---|
| **DesignSystem** | `DSSpacing`, `DSTypography`, `DSRadius`, `DSColor`, skeleton modifiers | Nothing from app |
| **Networking** | `NetworkClient`, `URLSessionNetworkClient`, `NetworkError` | Foundation only |

Views, ViewModels, UseCases, Repositories, DI, and Navigation remain in the app target.

## Why I used packages at all

**Boundaries.** Networking cannot accidentally import SwiftUI. DesignSystem cannot reference ViewModels.

**Reuse.** Another target could depend on `Networking` without copying files.

**Compile isolation.** Small packages rebuild faster when I touch unrelated app code.

**Learning.** Modularization was its own chapter; I wanted the repo to show a split early, even for a small app.

### What I did

Two packages: visual tokens + HTTP transport. Everything feature-specific stays in the app.

### Why (then)

These were the only pieces that felt genuinely reusable and framework-free. Geoapify DTOs belong to this app, not a generic library.

### What I'd reconsider

If compile time or team size grew, I would extract `Domain`, then feature modules. Today one target is faster to open and debug than five local packages.

## Why I did not modularize features

Common next steps in bigger codebases:

| Module | What it would contain |
|---|---|
| `HomeFeature` | `HomeView`, `HomeViewModel`, `HomeFactory` |
| `DetailFeature` | Detail screen + factory |
| `FavoritesFeature` | Favorites tab + SwiftData wiring |
| `Domain` package | Entities + UseCase protocols |
| `Data` package | Repositories, DTOs, mappers |

I did not do that here.

**App size.** Two tabs, one pushed screen. Feature modules pay off with parallel teams, slow builds, or optional binaries.

**Navigation and DI cross cuts.** `AppRoute` references `POI` everywhere. `DIContainer` wires all tabs. Splitting features means deciding who owns routes and factories up front. Solvable, extra ceremony for a study app.

**Thin Domain/Data.** A handful of entities and use cases. A `Domain` package shines with widgets, extensions, or multiple targets. Discover has one iOS app.

I optimized for learning layer boundaries inside one target first. Feature modules feel like a later chapter, not a prerequisite for MVVM or repositories.

## When I would split features

- Compile time hurts on every View tweak
- Two people conflict daily on the same target
- A feature ships or A/B tests independently
- A widget or App Clip needs Home without Favorites

Rough target layout:

```
Packages/
  DesignSystem/
  Networking/
  Domain/
  Data/
  Navigation/
App/
  DiscoverApp/         @main, DIContainer, TabView
  HomeFeature/
  DetailFeature/
  FavoritesFeature/
```

Each feature depends on `Domain` and `Navigation`, not sibling features. The app target composes them in `DIContainer`.

## DesignSystem

Shared tokens so screens do not hardcode `16` or `.blue`:

- Spacing (`DSSpacing.md`)
- Typography + Dynamic Type
- Category colors for POI cards
- Skeleton shimmer for loading

Presentation imports `DesignSystem`. The package knows nothing about POIs.

## Networking package

HTTP abstraction only. Geoapify DTOs stay in app Data. See [Networking](/architecture/networking/) for why URL building also stayed in Repositories.

## Could everything stay in one target?

Yes. Many study apps do. I extracted DesignSystem and Networking to practice Package boundaries without the cost of feature modules.

## Adding a package

1. File → New → Package in Xcode (or folder + `Package.swift`)
2. Add local package dependency to `blueprint` target
3. Keep Domain entities out of packages unless multiple targets need them

## Read next

- [Networking](/architecture/networking/)
- [Architecture Overview](/architecture/overview/)
