---
title: Navigation
summary: NavigationStack, AppRoute, and RouterProtocol.
chapter: 4
status: done
---
# Navigation

Navigation is programmatic and type-safe using `NavigationStack` and a route enum.

## Core types

- **`AppRoute`** — every destination the app can navigate to
- **`AppRouter`** — concrete router holding the navigation path
- **`RouterProtocol`** — abstraction ViewModels depend on

```swift
enum AppRoute: Hashable {
    case detail(POI)
}
```

ViewModels call `router.push(.detail(poi))` instead of manipulating `NavigationPath` directly. This keeps navigation testable and decoupled from SwiftUI views.
