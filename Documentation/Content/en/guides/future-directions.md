---
title: Future Directions
summary: Open study ideas, architectural alternatives, and fork prompts. Not a commitment backlog.
order: 7
---
# Future Directions

Blueprint is a **study project**. This page lists ideas for forks, PRs, and personal learning paths.

Nothing here is a promise to implement. The [Roadmap](/guides/roadmap/) tracks chapters the maintainer plans to ship. This page tracks **what could be explored differently** and why.

## How to use this page

1. Pick an idea that fits your context (team, app size, deadline).
2. Read the current Blueprint article and ADR for that area.
3. Implement in a fork or branch.
4. Write an ADR explaining context, alternatives, decision, and consequences.
5. Open a PR if you want to contribute the experiment back.

There is no single correct architecture. These prompts exist so you practice **evaluating trade-offs**, not copying answers.

---

## Architecture and navigation

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| Navigation | `NavigationStack` + `AppRoute` + `RouterProtocol` | **UIKit-style Coordinators** | Large apps with complex flows, UIKit interop, multiple entry points |
| State | MVVM + `UIState` enums | **TCA** (The Composable Architecture) | Heavy state machines, time-travel debugging, shared reducers |
| Modules | Layers in one app target + 2 packages | **Feature modules** (Home, Detail as packages) | Teams owning features independently |
| Boundaries | Protocol-driven Clean Architecture | **Pragmatic "lite" layers** | Tiny apps where full layering is overhead |

**Study prompt:** Reimplement Home → Detail flow with a Coordinator. Compare testability and file count against [Navigation](/architecture/navigation/).

---

## Dependency injection

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| Wiring | `DIContainer` + bundles + factories | **Swinject** or **Factory** | Graph grows past ~20 types, need scoped lifetimes |
| Discovery | Explicit `init` wiring | **Service locator** (anti-pattern study) | Understand why Blueprint avoids it |
| Compile-time | Manual factories | **Needle** (Uber) | Large graphs, compile-time safety at scale |

**Study prompt:** Swap `POIDependencies` to Factory library. Measure boilerplate before/after. Document where implicit resolution helped or hurt.

Related: [Dependency Injection](/architecture/dependency-injection/), [ADR 0003](/decisions/0003-dependency-injection/).

---

## Concurrency and cache

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| Cache isolation | `@MainActor` `POICacheService` | **`actor` POICacheService** | Heavy disk I/O off main thread |
| Debounce | `Task.sleep` + cancel in ViewModel | **Combine** debounce | iOS 16 support, reactive pipelines |
| Default isolation | `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` | **Strict `Sendable` audit** | Libraries shared across targets |

**Study prompt:** Move cache read/write to an `actor`. List every type that needs `nonisolated` or `await`. Compare with [Concurrency](/architecture/concurrency/).

---

## Networking and data

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| HTTP client | `URLSessionNetworkClient` | **Alamofire** or generated OpenAPI client | Interceptors, retries, codegen from Geoapify spec |
| API keys | `xcconfig` → `Info.plist` | **Firebase Remote Config** (like Native Birds) | Keys rotated without App Store release |
| DTOs | Hand-written mappers | **Codable macros / codegen** | Many endpoints, schema churn |
| Pagination | Offset in `HomeViewModel` | **AsyncSequence** stream | Infinite scroll with backpressure |

**Study prompt:** Replace `LocalFeatureFlagService` with Remote Config and move API key fetch to runtime. Compare security model with [API Key Setup](/guides/api-key-setup/).

---

## Persistence

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| Favorites | SwiftData `FavoritePOI` | **Core Data** | Existing Core Data stack, migration tools |
| Domain model | Separate `@Model` from `POI` | **Single model** (anti-pattern study) | See why Domain stays clean |
| Sync | Local only | **CloudKit** or **iCloud SwiftData** | Multi-device favorites |

**Study prompt:** Add in-memory SwiftData tests for `FavoritesRepository`. Close the gap noted in [Testing](/architecture/testing/).

---

## Testing and quality

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| Framework | Swift Testing | **XCTest** migration study | Legacy suites, UI test integration |
| Coverage | 70% target, local only | **CI coverage gate** (`xccov`, Codecov) | Teams enforcing quality bars |
| UI | No snapshot tests | **swift-snapshot-testing** | Design System regression |
| E2E | None | **XCUITest** smoke flow | Critical paths before release |

**Study prompt:** Add `-enableCodeCoverage YES` to GitHub Actions and fail PRs below 70%. Document setup in [CI/CD](/guides/ci-cd/).

---

## Tooling and delivery

| Topic | Blueprint today | Alternative to explore | When it might make sense |
|---|---|---|---|
| CI | GitHub Actions + `xcodebuild` | **Fastlane** (`scan`, `match`, `pilot`) | TestFlight automation, signing teams |
| Project gen | Raw `.xcodeproj` | **Tuist** or **XcodeGen** | Multi-target scaling, reproducible projects |
| Lint | SwiftLint in CI | **SwiftFormat** + custom rules | Stricter style enforcement |
| Docs | Saga static site | **DocC** host on GitHub Pages | API reference for packages |

**Study prompt:** Add a Fastlane lane that runs tests and uploads to TestFlight. Compare with current [CI/CD](/guides/ci-cd/) workflow.

---

## Product and platform (Discover)

| Topic | Status | Idea | Notes |
|---|---|---|---|
| Deep links | Planned v0.13 | `blueprint://place/:id`, Universal Links | Already on [Roadmap](/guides/roadmap/) |
| Map | Flag off | Enable `POIMapView` by default | `.mapView` exists in code |
| Category filter | Flag unused | Wire `.categoryFilter` in Home | Enum exists, UI not built |
| Widgets | Not started | POI nearby widget (WidgetKit) | Needs App Group + shared cache |
| watchOS / iPad | Not started | Separate targets from packages | Tests modularization boundaries |
| Offline mode | Partial | Cache-only mode when network fails | Extend `POICacheService` policy |

---

## Documentation and community

| Idea | Why |
|---|---|
| **pt-BR translation** | Planned v0.17. Good first contribution for Brazilian devs |
| **Contributing guide** | How to open a chapter PR, ADR format, test requirements |
| **Chapter template** | Scaffold for "v0.x: Topic" with code + doc + ADR checklist |
| **Comparison posts** | "Blueprint vs Native Birds: same pattern, different domain" |

---

## Suggesting something new

Open a GitHub Issue with:

- **Problem** you want to explore
- **Alternative** approach
- **Why** it might beat the current Blueprint choice in *your* context
- **Scope** you are willing to implement

If it ships as a chapter, it moves to the [Roadmap](/guides/roadmap/) with a version number and optionally becomes an ADR.

---

## Related

- [Roadmap](/guides/roadmap/) (committed chapters)
- [Architecture Overview](/architecture/overview/)
- [ADR index](/decisions/)
