---
title: Navigation
summary: NavigationStack, AppRoute, AppRouter, and RouterProtocol for testable routing.
order: 3
---
# Navigation

## The problem

Views that manipulate `NavigationPath` directly are hard to test and tightly coupled to SwiftUI navigation APIs.

## Why NavigationStack + typed routes

`AppRoute` enum makes every destination explicit. `RouterProtocol` lets ViewModels push routes without owning navigation state.

## Alternatives considered

| Approach | Verdict |
|---|---|
| Coordinator (UIKit-style) | Heavy for SwiftUI |
| Environment-based navigation | Implicit, hard to test |
| **NavigationStack + RouterProtocol** | ✅ Chosen |

## Trade-offs

- **Pro:** Type-safe, testable, programmatic
- **Pro:** `@Observable` router — no Combine
- **Con:** Router stays in app target (references domain types from all features)

## How Blueprint implements it

```swift
enum AppRoute: Hashable {
    case detail(poi: POI)
}

@MainActor @Observable
final class AppRouter: RouterProtocol {
    var path: [AppRoute] = []
    func push(_ route: AppRoute) { ... }
}
```

Views receive `any RouterProtocol`, not `AppRouter`.

## Related code

- `blueprint/Navigation/AppRoute.swift`
- `blueprint/Navigation/AppRouter.swift`
- `blueprint/Navigation/RouterProtocol.swift`
- `blueprint/Navigation/AppRouterView.swift`

## Further reading

- [ADR 0002: Navigation](/decisions/0002-navigation/)
- [Observation](/concepts/observation/)
