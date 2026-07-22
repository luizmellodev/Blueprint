---
title: Observation
summary: @Observable for ViewModels and Router — replacing ObservableObject without Combine.
order: 1
---
# Observation

## The problem

`ObservableObject` + `@Published` + Combine adds boilerplate and an import every ViewModel and router needs.

## Why @Observable (iOS 17+)

SwiftUI tracks property access automatically. No `@Published`, no `objectWillChange`, no Combine.

## Where Blueprint uses it

| Type | Role |
|---|---|
| `HomeViewModel` | Screen state |
| `DetailViewModel` | Detail state |
| `AppRouter` | Navigation path |

Views hold `@State var viewModel` — changes propagate automatically.

## Alternatives

| Approach | When |
|---|---|
| `@Observable` | ✅ Default for reference-type state holders |
| `ObservableObject` | Legacy / iOS 16 support (not needed here) |
| Value-type state in View | Simple local UI state only |

## Related code

- `blueprint/Presentation/Views/Home/HomeViewModel.swift`
- `blueprint/Navigation/AppRouter.swift`

## Further reading

- [ADR 0004: Observable State](/decisions/0004-observable-state/)
- [Navigation](/architecture/navigation/)
