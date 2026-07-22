---
title: Navigation
summary: NavigationStack, AppRoute enum, AppRouter, and RouterProtocol for typed programmatic routing.
order: 6
---
# Why Navigation?

Discover has two primary destinations: **Home** and **Detail(POI)**. Navigation must be type-safe, testable, and owned outside individual views.

## What problem does this solve?

Views that mutate `NavigationPath` directly are hard to unit test and tightly coupled to SwiftUI APIs. ViewModels that know about `NavigationStack` cannot run in isolation.

## Why this solution?

| Piece | Role |
|---|---|
| `AppRoute` | Hashable enum: `.home`, `.detail(poi:)` |
| `AppRouter` | `@Observable` holder of `path: [AppRoute]` |
| `RouterProtocol` | ViewModels call `push` / `pop` / `popToRoot` |
| `AppRouterView` | Root `NavigationStack`, injects container + router |

ViewModels depend on `any RouterProtocol`, not `AppRouter`.

## Alternatives

| Approach | Verdict |
|---|---|
| UIKit Coordinator | Rejected: heavy in SwiftUI-first app |
| EnvironmentObject router | Rejected: implicit, harder to mock |
| Untyped `[Hashable]` routes | Rejected: loses compile-time POI payload |
| **NavigationStack + AppRoute + protocol** | Chosen |

## Trade-offs

- **Pro:** Compiler validates route payloads (`POI` in `.detail`)
- **Pro:** Router tested/mocked independently
- **Pro:** `@Observable` router, no Combine
- **Con:** Lives in app target (references Domain types)
- **Con:** Zoom transitions require extra `Namespace` wiring in factory

## How Blueprint implements it

`HomeViewModel` pushes `.detail(poi:)` through injected router.

`AppRouterView` hosts `NavigationStack(path: $router.path)` and uses factories for destination builders.

iOS 18 zoom transition: `HomeFactory` receives `Namespace.ID` for matched geometry between list and detail.

```mermaid
flowchart LR
  VM[HomeViewModel]
  R[RouterProtocol]
  AR[AppRouter path]
  NS[NavigationStack]
  VM -->|push detail| R --> AR --> NS
```

## Related code

- `blueprint/Navigation/AppRoute.swift`
- `blueprint/Navigation/AppRouter.swift`
- `blueprint/Navigation/RouterProtocol.swift`
- `blueprint/Navigation/AppRouterView.swift`
- `blueprint/Presentation/Views/Components/ZoomTransitionModifier.swift`

## Further reading

- [ADR 0002: Navigation](/decisions/0002-navigation/)
- [Observation](/architecture/observation/)
- [MVVM](/architecture/mvvm/)
