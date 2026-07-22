---
title: "0004: @Observable over ObservableObject"
summary: Use Observation framework for ViewModels and Router on iOS 17+.
status: accepted
date: 2026-03-22
order: 4
---
# 0004: @Observable over ObservableObject

## Status

Accepted

## Context

Minimum deployment is iOS 17. State holders include ViewModels and AppRouter.

## Problem

`ObservableObject` requires `@Published`, `import Combine`, and manual `objectWillChange` for non-`@Published` properties.

## Alternatives

1. **ObservableObject + Combine:** iOS 13+, verbose
2. **@Observable:** iOS 17+, automatic tracking
3. **Value-type state in View:** limited to simple local state

## Decision

All reference-type state holders use `@Observable`. No `ObservableObject` in the project.

## Consequences

**Positive:**
- Less boilerplate
- No Combine import in ViewModels
- Consistent pattern across ViewModels and Router

**Negative:**
- iOS 17+ only (already a project requirement)

## References

- [Observation](/architecture/observation/)
- `blueprint/Presentation/Views/Home/HomeViewModel.swift`
- `blueprint/Navigation/AppRouter.swift`
