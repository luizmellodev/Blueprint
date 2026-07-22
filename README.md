# Blueprint

A production-grade iOS architecture reference built with modern SwiftUI. The example app, **Discover**, shows Points of Interest (POIs) using the [Geoapify API](https://www.geoapify.com/).

Every technical decision exists to teach. Nothing enters the project without a didactic reason.

---

## What you'll learn

- **Clean Architecture** — Domain, Data, Presentation layers with strict dependency rules
- **Dependency Injection** — DIContainer + Factories + dependency bundles, zero frameworks
- **Navigation** — `NavigationStack` + `AppRoute` enum + `RouterProtocol` for testable navigation
- **Modern Swift** — `@Observable`, `async/await`, `Swift Testing`, `@MainActor`
- **SwiftData** — persistence in the Data layer, Domain stays clean
- **Design System** — local Swift Package with spacing, typography, color, and skeleton tokens
- **Feature Flags** — type-safe `FeatureFlag` enum with a swappable backend
- **Accessibility** — VoiceOver labels, Dynamic Type, `accessibilityElement` patterns
- **CI/CD** — GitHub Actions with SwiftLint + build + test on every PR

---

## Architecture

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
| Feature flags | `FeatureFlag` enum + protocol | Type-safe, swappable backend (local → RemoteConfig) |
| Tests | Swift Testing (`@Test`, `#expect`) | Modern, ships with Xcode |

---

## Getting started

### Prerequisites

- Xcode 16+
- iOS 17+ simulator or device
- Free [Geoapify API key](https://www.geoapify.com/) (3,000 requests/day)

### Setup

1. Clone the repository
2. Copy `Config.xcconfig.sample` to `Config.xcconfig` and replace `your_api_key_here` with your Geoapify key (`Config.xcconfig` is gitignored — never commit it)
3. Open `blueprint.xcodeproj` in Xcode
4. Build and run on a simulator (⌘R)

### Running tests

```
⌘U in Xcode, or:
xcodebuild test -project blueprint.xcodeproj -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

---

## Roadmap

| Week | Topics | Status |
|---|---|---|
| 1 | Project setup → Packages → Navigation → DI | ✅ Done |
| 2 | Networking → API → Cache → Swift Testing | ✅ Done |
| 3 | Location → SwiftData → Feature Flags → Accessibility → CI | ✅ Done |
| 4 | Documentation → Website → Deploy | ⏳ Pending |

---

## Documentation

Each chapter lives in [`Documentation/chapters/`](Documentation/chapters/). The static site is built with [Saga](https://getsaga.dev/) from the [`Website/`](Website/) folder.

```bash
brew install loopwerk/tap/saga
./scripts/saga dev --port 3000
```

The TODOs in the source code (`// TODO: Explain why X`) are the source material — they become prose after each chapter closes.

Deploy instructions: [`Website/README.md`](Website/README.md).

---

## License

MIT
