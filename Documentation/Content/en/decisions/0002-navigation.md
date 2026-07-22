---
title: "0002: NavigationStack with RouterProtocol"
summary: Type-safe AppRoute enum and RouterProtocol abstraction for testable navigation.
status: accepted
date: 2026-03-08
order: 2
---
# 0002: NavigationStack with RouterProtocol

## Status

Accepted

## Context

Discover needs Home → Detail navigation with a typed `POI` payload. ViewModels should trigger navigation without owning `NavigationStack` state.

## Problem

Views that push routes directly are hard to test and tightly coupled to SwiftUI. UIKit Coordinators felt heavy for a two-screen SwiftUI app.

## Alternatives

1. **UIKit Coordinator:** familiar, verbose in SwiftUI
2. **EnvironmentObject router:** implicit, hard to mock
3. **NavigationStack + AppRoute + RouterProtocol:** typed, injectable

## Decision

`AppRoute` enum (`.home`, `.detail(poi:)`). `AppRouter` holds `path: [AppRoute]`. ViewModels depend on `RouterProtocol`, not `AppRouter`.

## What worked

- Mock router in tests without spinning up `NavigationStack`.
- Compiler rejects invalid routes (Detail requires a `POI`).
- `@Observable` router avoids Combine for navigation state.
- iOS 18 zoom transition wired through factory + namespace without polluting ViewModel.

## What hurt

- Router lives in app target forever (references Domain `POI`).
- Every new destination adds an `AppRoute` case and factory wiring.
- Deep links (planned v0.13) will stress this enum unless we plan URL mapping early.

## What we changed later

- Added `RouterProtocol` abstraction after starting with concrete `AppRouter` in Views (refactor made ViewModels testable).
- `AppRoute.home` exists for stack consistency even when root is fixed in `AppRouterView`.

## References

- [Navigation](/architecture/navigation/)
- `blueprint/Navigation/`
