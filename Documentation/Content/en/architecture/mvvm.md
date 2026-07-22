---
title: MVVM
summary: Views, ViewModels, and UIState enums. Presentation talks to Domain through UseCases only.
order: 2
---
# Why MVVM?

Discover separates SwiftUI views from screen logic using **Model-View-ViewModel**. The "Model" at this layer is Domain data (`POI`, `PlaceDetails`) plus `UIState` enums, not SwiftData models.

## What problem does this solve?

Without a ViewModel boundary, views accumulate networking calls, pagination rules, debounce logic, and error handling. That makes screens hard to test and impossible to reuse.

Blueprint also avoids **Massive ViewModel** by pushing business rules into UseCases. ViewModels orchestrate UI state; UseCases orchestrate domain work.

## Why this solution?

| Piece | Role in Blueprint |
|---|---|
| **View** | Renders state, forwards user actions |
| **ViewModel** | Holds `@Observable` state, calls UseCases |
| **UIState** | Explicit screen phase: idle, loading, success, failure |

ViewModels depend on **protocols** (`FetchNearbyPOIsUseCaseProtocol`, `RouterProtocol`), not concrete repositories.

## Alternatives

| Approach | Verdict |
|---|---|
| Logic inside SwiftUI `View` | Simple for demos; untestable at scale |
| MVC with UIViewController | UIKit pattern; fights SwiftUI |
| TCA / Redux-style global store | Powerful; heavy for a teaching codebase |
| **MVVM + UseCases** | Chosen: testable, layered, familiar |

## Trade-offs

- **Pro:** ViewModels tested with mocks (`HomeViewModelTests`, `HomeViewModelPaginationTests`)
- **Pro:** Views stay declarative; state changes drive re-renders via `@Observable`
- **Pro:** UseCases keep ViewModels thin
- **Con:** More files per screen (View, ViewModel, UIState, Factory)
- **Con:** Boilerplate compared to a single-file prototype

## How Blueprint implements it

**Screens today**

| Screen | View | ViewModel | UIState |
|---|---|---|---|
| Home | `HomeView` | `HomeViewModel` | `HomeUIState` |
| Detail | `DetailView` | `DetailViewModel` | `DetailUIState` |

**HomeViewModel responsibilities** (actual code):

- Resolve coordinates via `LocationServiceProtocol`
- Fetch POIs via `FetchNearbyPOIsUseCaseProtocol`
- Paginate with `pageSize = 20` and `loadMore()`
- Debounce search with `Task.sleep` + cancel (300 ms text, 400 ms geocoding)
- Guard `load()` with `guard case .idle` to avoid refetch when returning from Detail

**DetailViewModel responsibilities**:

- Start from `.success(poi)` passed by navigation
- Load optional `PlaceDetails` asynchronously (silent failure)
- Toggle favorites via `FavoritesUseCaseProtocol`
- Read `.favorites` feature flag at init

**Wiring**

`HomeFactory` and `DetailFactory` assemble ViewModels. Views never call `init` on repositories.

```mermaid
flowchart LR
  V[HomeView / DetailView]
  VM[ViewModel]
  ST[HomeUIState / DetailUIState]
  UC[UseCase protocols]
  V -->|user action| VM
  VM -->|@Observable state| V
  VM --> ST
  VM --> UC
```

## Related code

- `blueprint/Presentation/Views/Home/HomeView.swift`
- `blueprint/Presentation/Views/Home/HomeViewModel.swift`
- `blueprint/Presentation/Views/Home/HomeUIState.swift`
- `blueprint/Presentation/Views/Detail/DetailView.swift`
- `blueprint/Presentation/Views/Detail/DetailViewModel.swift`
- `blueprint/Presentation/Views/Detail/DetailUIState.swift`
- `blueprint/DI/Factories/HomeFactory.swift`
- `blueprint/DI/Factories/DetailFactory.swift`

## Further reading

- [Observation](/architecture/observation/)
- [Use Cases](/concepts/use-cases/)
- [Dependency Injection](/architecture/dependency-injection/)
- [Testing](/architecture/testing/)
