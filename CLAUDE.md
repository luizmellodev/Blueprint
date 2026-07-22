# Blueprint — CLAUDE.md

## What is this project

**Blueprint** is a public iOS architecture reference built with modern SwiftUI. The example app is called **Discover** and shows Points of Interest (POIs) using the Geoapify API. Every technical decision exists to teach — nothing enters the project without a didactic reason.

- **Repository name:** Blueprint
- **App name:** Discover
- **Domain:** Points of Interest (POIs) — places, restaurants, museums, parks, hotels
- **API:** Geoapify (free tier, 3000 req/day)
- **Minimum deployment target:** iOS 17

---

## Rules

### Git
- **Never** run `git commit` or `git push` — always provide the command for the user to run
- One commit per logical change — never accumulate everything into one giant commit

### Swift files
Every Swift file must start with the standard Xcode header:
```swift
//
//  FileName.swift
//  blueprint
//
//  Created by Luiz Mello on DD/MM/YY.
//
```

### Xcode actions
- Never use the terminal to create groups, move files, or delete files — these are done inside Xcode
- When a new file needs to be added to a target, tell the user to do it in Xcode

### Code style
- No comments explaining WHAT the code does — only `TODO:` markers for future documentation
- TODO format: `// TODO: Explain why X` — these become `.md` files after the chapter closes
- No abstractions beyond what the current task requires
- No error handling for scenarios that can't happen
- No backwards-compatibility shims
- **One type per file** — each `struct`, `class`, `enum`, `protocol`, and `actor` gets its own file named after it. Exception: `private` helper types that only make sense in the context of their parent file (e.g. `CodablePOI` inside `POICacheService.swift`)

---

## Architecture

```
App Target (blueprint)
├── App/                        # @main entry point
├── Navigation/                 # AppRoute, AppRouter, RouterProtocol, AppRouterView
├── DI/
│   ├── DIContainer             # Root assembler (@MainActor, created once)
│   ├── Core/                   # Dependency bundles per concern
│   │   ├── NetworkDependencies
│   │   ├── POIDependencies
│   │   ├── LocationDependencies
│   │   ├── PersistenceDependencies
│   │   └── FeatureFlagDependencies
│   └── Factories/              # One factory per screen
│       ├── HomeFactory
│       └── DetailFactory
├── Domain/
│   ├── Entities/               # POI, AppError, PagedResult — no external dependencies
│   └── Networking/             # NetworkClient protocol + URLSessionNetworkClient
├── Data/
│   ├── DTO/                    # GeoapifyDTOs + GeoapifyMapper
│   ├── Cache/                  # POICacheService (actor, 5-min TTL)
│   ├── Location/               # LocationServiceProtocol, LocationService
│   ├── Persistence/            # FavoritePOI (@Model), FavoritesRepository, FavoritesUseCase
│   ├── FeatureFlags/           # FeatureFlag enum, FeatureFlagService
│   └── Repositories/           # POIRepository, FetchNearbyPOIsUseCase
└── Presentation/
    └── Views/
        ├── Home/               # HomeView, HomeViewModel, HomeUIState
        └── Detail/             # DetailView, DetailViewModel, DetailUIState

Packages/
└── DesignSystem/               # DSSpacing, DSTypography, DSRadius (public tokens, iOS 17+)

Documentation/                  # One .md per chapter, written after the chapter closes
```

---

## Patterns and decisions

| Topic | Decision | Why |
|---|---|---|
| State management | `@Observable` (iOS 17+) | Simpler than ObservableObject, no need to import Combine |
| Navigation | `NavigationStack` + `AppRoute` enum | Programmatic, type-safe, testable |
| Router abstraction | `RouterProtocol` | ViewModels depend on the protocol, not the concrete AppRouter |
| DI | DIContainer + Factories, no framework | Explicit wiring, easy to trace, no magic |
| Dependency grouping | Bundles (NetworkDependencies, etc.) | Prevents flat container from growing unmanageable |
| UseCase | `struct` conforming to `Sendable` protocol | Stateless, value semantics, easy to test |
| Cache | `actor` | Protects file I/O from data races without manual locks |
| Persistence | SwiftData — `@Model` stays in Data layer | Domain stays clean; `POI` never becomes a SwiftData class |
| Feature flags | `FeatureFlag` enum + `FeatureFlagServiceProtocol` | Type-safe flags, swappable backend (local → RemoteConfig) |
| Tests | Swift Testing (`@Test`, `#expect`) | Modern, expressive, ships with Xcode |

---

## Layer rules

- **Domain** knows nothing about SwiftData, Combine, UIKit, or any framework
- **Data** knows Domain, but Domain does not know Data
- **Presentation** knows Domain and calls UseCases — never calls Repositories directly
- **Navigation** stays in the app target (not a Package) — AppRoute references domain types from all features
- **DesignSystem** is a local Swift Package with no app-layer dependencies

---

## Security

- `blueprint/Secrets.swift` is in `.gitignore` and must **never** be committed
- Structure: `enum Secrets { static let geoapifyAPIKey = "..." }`
- The file must be created manually after cloning

---

## Documentation strategy

Following the project's own guidelines:
1. During development: leave `// TODO: Explain why X` in the relevant files
2. After a chapter closes: write `Documentation/ChapterName.md` converting those TODOs into prose
3. After ~10 chapters: build a website that reads those Markdown files

---

## Roadmap

| Week | Topics | Status |
|---|---|---|
| 1 | Project setup → Packages → Navigation → DI | ✅ Done |
| 2 | Networking → API → Cache → Swift Testing | ✅ Done |
| 3 | Location → SwiftData → Feature Flags → Accessibility | 🔄 In progress |
| 4 | Website → Diagrams → Robust CI → Deploy | ⏳ Pending |

### Chapters (for Documentation/)
1. Creating the project
2. Modularization
3. Design System
4. Navigation
5. Dependency Injection
6. Networking
7. Persistence
8. Testing
9. Accessibility
10. CI/CD
11. Performance
12. Deploying documentation

---

## Reference project

The native-birds project (`~/Downloads/native-birds-main 2/`) was used as architecture reference. Key patterns borrowed: DIContainer + Factories, RouterProtocol, UIState enum per screen, dependency bundles. Key differences: Blueprint uses `@Observable` instead of `ObservableObject + Combine`, and modularizes with Swift Packages from the start.
