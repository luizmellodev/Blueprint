---
title: Blueprint
slug: index
---

## What this is

**Blueprint** is a public iOS architecture **study project** built with modern SwiftUI. It is not a template, a snippet collection, or a course. Every technical decision exists to teach and to explore best practices in the open.

**It should not be used as a 100% correct reference.** Architecture depends on each project: team size, product scope, client decisions, deadlines, and existing code. Use Blueprint to understand patterns and trade-offs, then adapt to your context.

Blueprint started from **[Native Birds](https://github.com/spanesso/native-birds)** by [Sebastian Panesso](https://github.com/spanesso) (`spanesso`), adapted to a POI domain with its own chapters, documentation, and ADRs.

The repository ships a runnable example app and this documentation site. Markdown in `Documentation/` is the source of truth. The site is navigation and rendering.

## Discover

**Discover** is the app target inside Blueprint. It lists Points of Interest (POIs) near the user's location: restaurants, museums, parks, hotels, and more.

The domain is deliberately generic so architecture stays in focus. Navigation, dependency injection, networking, caching, location, persistence, and SwiftUI presentation are the subject, not product features.

| | |
|---|---|
| **App name** | Discover |
| **Repository** | Blueprint |
| **Minimum deployment** | iOS 17 |
| **UI framework** | SwiftUI with `@Observable` |

Blueprint follows **Clean Architecture with protocol-driven boundaries**, inspired by [Native Birds](https://github.com/spanesso/native-birds) by Sebastian Panesso.

| Layer | Protocol examples |
|---|---|
| Presentation | ViewModels depend on `FetchNearbyPOIsUseCaseProtocol`, `RouterProtocol` |
| Domain | UseCases depend on `POIRepositoryProtocol`, `FavoritesRepositoryProtocol` |
| Data | Repositories depend on `NetworkClient`, `ModelContext` (internal) |

Presentation never calls Repositories directly. Data never imports SwiftUI.

## Geoapify API

Discover loads POI data from [Geoapify](https://www.geoapify.com/), a free-tier geolocation API (3,000 requests/day, no credit card).

| | |
|---|---|
| **Used for** | Nearby places, place details, city geocoding |
| **Authentication** | API key in `Config.xcconfig`, injected into `Info.plist` |
| **Caching** | 5-minute TTL on disk via `POICacheService` |

See [Getting Started](/guides/getting-started/) to configure the API key locally.

## How this documentation is organized

**Code explains HOW.** The Swift codebase shows implementation: ViewModels, UseCases, Repositories, actors for cache.

**Documentation explains WHY.** Each article records the problem, alternatives considered, and trade-offs accepted.

| Section | Purpose |
|---|---|
| [Guides](/guides/) | Practical setup: clone, build, test, deploy |
| [Architecture](/architecture/) | Engineering decisions: layers, patterns, trade-offs |
| [Concepts](/concepts/) | Cross-cutting patterns (Use Cases, Logging) |
| [ADRs](/decisions/) | Formal decision records with context and consequences |
| [Roadmap](/guides/roadmap/) | Chapter-by-chapter project evolution |
| [Future Directions](/guides/future-directions/) | Study ideas, alternatives, and fork prompts (open) |
| [Contributing](/guides/contributing/) | PR format, ADR journal template, local checks |

## Architecture

Start with the full layer diagram, data flow, and feature breakdown:

**[Architecture Overview](/architecture/overview/)**

At a glance:

```
App Target (blueprint)
├── Navigation/       AppRoute, AppRouter, RouterProtocol
├── DI/               DIContainer, bundles, factories
├── Domain/           Entities, UseCases (zero framework imports)
├── Data/             Repositories, DTOs, SwiftData, cache
└── Presentation/     Views, ViewModels, UIState

Packages/
├── DesignSystem/     Shared tokens (spacing, typography, radius)
└── Networking/       NetworkClient protocol
```

## Next step

[Getting Started](/guides/getting-started/): clone the repo, add your Geoapify key, and run Discover in the simulator.
