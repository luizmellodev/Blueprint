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

Discover has multiple screens (Home, Detail, Search). Navigation must be programmatic, testable, and type-safe.

## Problem

Views manipulating `NavigationPath` directly couple UI to navigation mechanics and resist unit testing.

## Alternatives

1. **UIKit Coordinator:** familiar but heavy in SwiftUI
2. **EnvironmentObject router:** implicit, hard to mock
3. **NavigationStack + AppRoute + RouterProtocol:** typed, injectable

## Decision

`AppRoute` enum defines destinations. `AppRouter` holds `path: [AppRoute]`. Views depend on `RouterProtocol`.

## Consequences

**Positive:**
- Testable navigation (mock router)
- Type-safe pushes, compiler catches invalid routes
- `@Observable` router without Combine

**Negative:**
- Router stays in app target (references `POI` and feature destinations)
- Each new screen adds a case to `AppRoute`

## References

- [Navigation](/architecture/navigation/)
- `blueprint/Navigation/`
