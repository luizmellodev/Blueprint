---
title: Navigation
summary: How I typed routes and pushed screens from ViewModels.
order: 7
---
# Navigation

*How I navigated in SwiftUI with AppRoute and a small router.*

Discover uses `NavigationStack`, a typed route enum, and `RouterProtocol`. ViewModels call `router.push(...)` instead of hiding navigation inside Views.

## AppRoute

Every push destination:

```swift
enum AppRoute: Hashable {
  case home
  case detail(poi: POI)
}
```

`Hashable` so SwiftUI stores it in a navigation path and resolves `navigationDestination(for: AppRoute.self)`.

A sealed list of screens, not string URLs. The compiler knows `.detail` needs a `POI`.

## Navigation path

Each tab has its own stack and router:

```swift
@State private var homeRouter = AppRouter()
@State private var favoritesRouter = AppRouter()
```

`AppRouter` holds:

```swift
var path: [AppRoute] = []

func push(_ route: AppRoute) {
  guard path.last != route else { return }
  path.append(route)
}
```

`NavigationStack(path: $homeRouter.path)` binds the stack. Two tabs = two independent paths.

### What I did

`AppRoute` enum + `AppRouter` class + `RouterProtocol` for ViewModels.

### Why (then)

I wanted ViewModels to trigger navigation without importing SwiftUI navigation APIs everywhere. Tests could record `push(.detail(poi:))` with a mock router.

### What I'd reconsider

`AppRouterView` got busy with two stacks, factories, and `navigationDestination`. I might extract a small coordinator per tab if routes multiply.

## RouterProtocol

ViewModels depend on the protocol, not `AppRouter`:

```swift
protocol RouterProtocol {
  func push(_ route: AppRoute)
  func pop()
  func popToRoot()
}
```

## Wiring in AppRouterView

```swift
NavigationStack(path: $homeRouter.path) {
  container.homeFactory.makeView(router: homeRouter, namespace: zoomNamespace)
    .navigationDestination(for: AppRoute.self) { route in
      switch route {
      case .home:
        container.homeFactory.makeView(router: homeRouter, namespace: zoomNamespace)
      case .detail(let poi):
        container.detailFactory.makeView(poi: poi)
      }
    }
}
```

Factory creates the root. `navigationDestination` maps each case to a View.

## Could I navigate from the View only?

Yes. `NavigationLink(value: poi)` in the list, no router. Fine for simple flows. I pushed navigation into ViewModels to match MVVM habits from UIKit and to test "user tapped row → detail route" without ViewInspector.

## Coordinator, MVVM-C, or Router?

UIKit teams often use a **Coordinator** to own navigation. SwiftUI literature mentions **MVVM-C**.

I used `RouterProtocol` + `AppRouter`: same idea, smaller surface for three screens. A full Coordinator tree might help with deep links and modal flows I have not built yet.

## Read next

- [Dependency Injection](/architecture/dependency-injection/)
- [MVVM](/architecture/mvvm/)
