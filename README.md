# Blueprint

A public iOS architecture **study project** built with modern SwiftUI. The example app, **Discover**, helps you explore **places near you** (restaurants, museums, parks, hotels) using the [Geoapify API](https://www.geoapify.com/).

**POI** means *Point of Interest*: any place worth showing on a map. See [About Discover](Documentation/Content/en/guides/about-discover.md) for a plain-language product intro.

Blueprint is not a template, a snippet collection, or a course. Every technical decision exists to teach and to explore best practices in the open.

**It should not be used as a 100% correct reference.** Architecture depends on each project: team size, product scope, client decisions, deadlines, and existing code. Use Blueprint to understand patterns and trade-offs, then adapt to your context.

Adapted from Native Birds by Sebastian Panesso.

Blueprint follows **Clean Architecture with protocol-driven boundaries**: Presentation and Data depend on Domain through protocols, so UseCases, Repositories, and services are testable in isolation.

---

## What you'll learn

- **Clean Architecture:** Domain, Data, and Presentation layers with strict dependency rules
- **Dependency Injection:** DIContainer + Factories + dependency bundles, zero third-party frameworks
- **Navigation:** `NavigationStack` + `AppRoute` enum + `RouterProtocol` for testable navigation
- **Modern Swift:** `@Observable`, `async/await`, Swift Testing, `@MainActor`
- **SwiftData:** persistence in the Data layer; Domain stays clean
- **Design System:** local Swift Package with spacing, typography, color, and skeleton tokens
- **Feature Flags:** type-safe `FeatureFlag` enum with a swappable backend
- **Accessibility:** VoiceOver labels, Dynamic Type, `accessibilityElement` patterns
- **CI/CD:** GitHub Actions with SwiftLint, build, and test on every PR

---

## Architecture

Full overview with layer diagrams and data flow: **[Documentation/Content/en/architecture/overview.md](Documentation/Content/en/architecture/overview.md)** (also on the [docs site](https://github.com/luizmellodev/Blueprint) after deploy).

```
App Target (blueprint)
├── App/                    @main entry point
├── Navigation/             AppRoute, AppRouter, RouterProtocol, AppRouterView
├── DI/
│   ├── DIContainer         Root assembler (@MainActor, one instance)
│   ├── Core/               Dependency bundles (Network, POI, Location, Persistence, FeatureFlags)
│   └── Factories/          HomeFactory, DetailFactory
├── Domain/
│   ├── Entities/           POI, PlaceDetails, GeocodingResult, AppError, PagedResult
│   ├── UseCases/           FetchNearbyPOIsUseCase, FetchPlaceDetailsUseCase,
│   │                       SearchLocationUseCase, FavoritesUseCase
│   └── Networking/         NetworkClient protocol (Networking Package re-export)
├── Data/
│   ├── DTO/                GeoapifyDTOs, GeocodingDTOs, PlaceDetailsDTOs + Mappers
│   ├── Repositories/       POIRepository, PlaceDetailsRepository, GeocodingRepository
│   ├── Cache/              POICacheService (5-min TTL, file-backed)
│   ├── Location/           LocationService (CoreLocation)
│   ├── Persistence/        FavoritePOI (@Model), FavoritesRepository (SwiftData)
│   └── FeatureFlags/       FeatureFlag enum, LocalFeatureFlagService
└── Presentation/
    └── Views/
        ├── Home/           HomeView, HomeViewModel, HomeUIState
        └── Detail/         DetailView, DetailViewModel, DetailUIState

Packages/
├── DesignSystem/           DSSpacing, DSTypography, DSColor, DSRadius, SkeletonStyle
└── Networking/             NetworkClient protocol, URLSessionNetworkClient, NetworkError
```

---

## Layer rules

| Layer | Can depend on | Cannot depend on |
|---|---|---|
| Domain | nothing | Data, Presentation, UIKit, SwiftData |
| Data | Domain | Presentation |
| Presentation | Domain (via UseCases) | Data directly |
| DesignSystem | nothing | App target |

---

## Key patterns

| Topic | Decision | Why |
|---|---|---|
| State management | `@Observable` (iOS 17+) | Granular tracking, no Combine |
| Navigation | `NavigationStack` + `AppRoute` | Programmatic, type-safe |
| Router abstraction | `RouterProtocol` | ViewModels depend on protocol, not concrete router |
| DI | DIContainer + Factories, no framework | Explicit wiring, easy to trace |
| Dependency grouping | Bundles (NetworkDependencies, etc.) | Prevents flat container from growing unmanageable |
| UseCase | `struct` + `Sendable` | Stateless, value semantics |
| Cache | File-backed JSON, 5-min TTL | Survives app restart, avoids API rate limits |
| Persistence | SwiftData in Data layer only | Domain entity `POI` stays a plain struct |
| Feature flags | `FeatureFlag` enum + protocol | Type-safe, swappable backend (local to Remote Config) |
| Tests | Swift Testing (`@Test`, `#expect`) | Modern, ships with Xcode |

---

## Getting started

### Prerequisites

- Xcode 16+
- iOS 17+ simulator or device
- Free [Geoapify API key](https://www.geoapify.com/) (3,000 requests/day)

### Setup

1. Clone the repository
2. Copy `Config.xcconfig.sample` to `Config.xcconfig` and replace `your_api_key_here` with your Geoapify key (`Config.xcconfig` is gitignored; never commit it)
3. Open `blueprint.xcodeproj` in Xcode
4. Build and run on a simulator (⌘R)

### Running tests

```
⌘U in Xcode, or:
xcodebuild test -project blueprint.xcodeproj -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest'
```

### Testing and quality

- **Architecture:** Clean Architecture with protocol-driven boundaries (testable UseCases, Repositories, and services).
- **Framework:** Swift Testing (`@Test`, `#expect`).
- **Coverage target:** 70% on the `blueprint` app target (long-term goal).
- **CI floor:** GitHub Actions fails PRs below **20%** via `scripts/check-coverage.sh`.
- **How to measure:** Xcode → Report navigator → Coverage, or see [Running Tests](Documentation/Content/en/guides/running-tests.md).

---

## Roadmap

| Week | Topics | Status |
|---|---|---|
| 1 | Project setup, Packages, Navigation, DI | Done |
| 2 | Networking, API, Cache, Swift Testing | Done |
| 3 | Location, SwiftData, Feature Flags, Accessibility, CI | Done |
| 4 | Documentation, Website, Deploy | In progress |

---

## Documentation

Blueprint documentation lives in [`Documentation/`](Documentation/). Markdown is the source of truth. The site is navigation only.

```
Documentation/
├── ROADMAP.md
└── Content/
    ├── en/
    │   ├── guides/           Setup, tests, CI, deploy
    │   ├── architecture/     Engineering decisions by layer
    │   ├── concepts/         Patterns (Observation, Repository, etc.)
    │   └── decisions/        ADRs
    └── pt-BR/                Coming soon
```

**Philosophy:** Code explains HOW. Documentation explains WHY.

```bash
brew install loopwerk/tap/saga
./scripts/saga dev --port 3000
```

Deploy instructions: [`Website/README.md`](Website/README.md).

Contributing: [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## License

MIT
