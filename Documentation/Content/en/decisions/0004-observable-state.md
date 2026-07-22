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

Minimum deployment is iOS 17. ViewModels and `AppRouter` are reference-type state holders. The reference Native Birds project used older patterns; Blueprint committed to modern Observation from the start.

## Problem

`ObservableObject` + `@Published` adds boilerplate and forces Combine imports. Learners conflate "SwiftUI state" with "Combine pipelines."

## Alternatives

1. **ObservableObject + Combine:** broader OS support, verbose
2. **@Observable:** automatic tracking, iOS 17+
3. **Value-type state in View:** fine for local UI only

## Decision

All reference-type state holders use `@Observable`. No `ObservableObject` in production code.

## What worked

- Views use `@State var viewModel`; diffs feel natural after iOS 17.
- Same pattern for ViewModels and router (one macro to teach).
- Removed Combine imports from ViewModels entirely.

## What hurt

- iOS 17+ only (already a project constraint, but worth stating for forks).
- Test ergonomics: `@MainActor` mock types cannot be default parameters in test helpers (fixed by using optional params + nil coalescing in `HomeViewModelTests`).
- Team must learn `@State` vs `@Bindable` rules for two-way binding.

## What we changed later

- Migrated `AppRouter` from initial prototype that used `@Published path` (internal refactor before first public chapter).
- Documentation split: [Observation](/architecture/observation/) for pattern, this ADR for the decision story.

## References

- [Observation](/architecture/observation/)
- `blueprint/Presentation/Views/Home/HomeViewModel.swift`
- `blueprint/Navigation/AppRouter.swift`
