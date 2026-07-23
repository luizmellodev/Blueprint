---
title: Blueprint
slug: index
---

## What this is

**Blueprint** is a public iOS architecture **study project** — code and documentation written while learning, not a shipped product or a copy-paste template.

The repo holds two things:

- **Discover**, a small SwiftUI app you can run in the simulator
- **This site**, generated from Markdown in `Documentation/`

Docs record what exists in the codebase and why certain choices were made. They are updated as the project grows; some chapters are ahead of others, and not everything here is battle-tested.

Adapted from [Native Birds](https://github.com/spanesso/native-birds) by Sebastian Panesso.

## Discover

**Discover** lists places near you (restaurants, museums, parks, hotels) using the [Geoapify](https://www.geoapify.com/) API.

Two tabs — **Discover** and **Favorites** — each with its own navigation stack. **Detail** is a pushed screen, not a tab. The scope stays small on purpose so the write-ups can focus on architecture instead of product features.

| | |
|---|---|
| **App name** | Discover |
| **Repository** | Blueprint |
| **Minimum deployment** | iOS 17 |
| **UI framework** | SwiftUI with `@Observable` |
| **Product notes** | [About Discover](/guides/about-discover/) |

Blueprint follows **Clean Architecture with protocol-driven boundaries**.

| Layer | Protocol examples |
|---|---|
| Presentation | ViewModels depend on `FetchNearbyPOIsUseCaseProtocol`, `RouterProtocol` |
| Domain | UseCases depend on `POIRepositoryProtocol`, `FavoritesRepositoryProtocol` |
| Data | Repositories depend on `NetworkClient`, `ModelContext` (internal) |

Presentation never calls Repositories directly. Data never imports SwiftUI.

## Geoapify API

Discover loads place data from Geoapify (free tier: 3,000 requests/day, no credit card).

| | |
|---|---|
| **Used for** | Nearby places, place details, city geocoding |
| **Authentication** | API key in `Config.xcconfig`, injected into `Info.plist` |
| **Caching** | 5-minute TTL on disk via `POICacheService` |

See [Getting Started](/guides/getting-started/) to configure the API key locally.

## How this documentation is organized

Markdown in `Documentation/Content/en/` is the source of truth. This site renders it.

Articles describe **what the code does** and **which decisions were taken** — with links to ADRs when a choice was explicit. They are not step-by-step tutorials.

| Section | Purpose |
|---|---|
| [Guides](/guides/) | Setup, tests, CI, product context |
| [Architecture](/architecture/) | Layers, patterns, and how they map to the app |
| [Concepts](/concepts/) | Cross-cutting patterns (Observation, Repository, …) |
| [ADRs](/decisions/) | Decision records: context, choice, consequences |
| [Website](/website/) | How this site is built (Saga, Tailwind, deploy) |
| [Roadmap](/guides/roadmap/) | Chapter-by-chapter evolution |
| [Future Directions](/guides/future-directions/) | Ideas not yet implemented |
| [Contributing](/guides/contributing/) | PR format and local checks |

## Architecture

Layer diagram, data flow, and feature breakdown:

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

[Getting Started](/guides/getting-started/) — clone, API key, run the simulator.

For product vocabulary and screen map, see [About Discover](/guides/about-discover/).
