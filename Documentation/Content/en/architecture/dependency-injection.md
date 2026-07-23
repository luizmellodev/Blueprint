---
title: Dependency Injection
summary: How I wired Discover manually with DIContainer, bundles, and factories.
order: 6
---
# Dependency Injection

*How I connected clients, repositories, use cases, and screens without Swinject.*

Discover has a lot to wire: HTTP client, three repositories, several use cases, location, SwiftData, feature flags, three screens.

I inject dependencies through `init` instead of globals inside types.

## DIContainer

Created once in `AppRouterView`:

```swift
@State private var container = DIContainer()
```

`DIContainer` builds bundles, then factories:

```swift
@MainActor
final class DIContainer {
  let homeFactory: HomeFactory
  let detailFactory: DetailFactory
  let favoritesFactory: FavoritesFactory

  init() {
    let network = NetworkDependencies()
    let poi = POIDependencies(network: network)
    let location = LocationDependencies()
    let persistence = PersistenceDependencies()
    let featureFlags = FeatureFlagDependencies()

    homeFactory = HomeFactory(
      poi: poi, location: location,
      persistence: persistence, featureFlags: featureFlags
    )
    detailFactory = DetailFactory(persistence: persistence, featureFlags: featureFlags, poi: poi)
    favoritesFactory = FavoritesFactory(persistence: persistence)
  }
}
```

The whole graph fits in one file I can scroll through.

### What I did

Manual DI: `DIContainer` + dependency **bundles** + screen **factories**. No third-party container.

### Why (then)

On a study project I learn more when I see every wire. Native Birds (my reference) used the same pattern. I can grep "who creates `HomeViewModel`" and land in `HomeFactory`.

### What I'd reconsider

If the graph doubled in size I might extract a composition root per feature or try a lightweight container. For three screens, manual wiring still beats magic.

## Bundles

A bundle groups construction for one concern:

| Bundle | Creates |
|---|---|
| `NetworkDependencies` | `NetworkClient` |
| `POIDependencies` | Repositories + POI-related UseCases |
| `LocationDependencies` | `LocationService` |
| `PersistenceDependencies` | `ModelContainer`, `FavoritesUseCase` |
| `FeatureFlagDependencies` | `FeatureFlagService` |

Example from `POIDependencies`:

```swift
init(network: NetworkDependencies) {
  let repository = POIRepository(client: network.client, apiKey: Secrets.geoapifyAPIKey)
  fetchNearbyPOIs = FetchNearbyPOIsUseCase(repository: repository)
  // ...
}
```

Bundles keep `DIContainer` from becoming hundreds of lines.

## Factories

A factory builds one screen: View + ViewModel with the right dependencies.

```swift
final class HomeFactory {
  func makeView(router: any RouterProtocol, namespace: Namespace.ID) -> some View {
    let viewModel = HomeViewModel(
      fetchNearbyPOIs: poi.fetchNearbyPOIs,
      searchLocation: poi.searchLocation,
      locationService: location.locationService
    )
    return HomeView(viewModel: viewModel, router: router, namespace: namespace)
  }
}
```

Views do not construct UseCases. Adding a dependency to Home means editing `HomeFactory`, not every preview.

## App entry

```swift
@main
struct blueprintApp: App {
  var body: some Scene {
    WindowGroup {
      AppRouterView()
    }
  }
}
```

`AppRouterView` owns the container and calls `container.homeFactory.makeView(router:)` inside each tab's `NavigationStack`.

## Could I use `@Environment` instead?

Yes for app-wide services (theme, analytics). I still wanted explicit constructor injection for UseCases and repositories so tests and factories stay obvious. I might mix both on a larger app: Environment for truly global stuff, factories for screen graphs.

## Could I use Swinject or Factory?

Yes. Less boilerplate when the graph grows. I skipped them here so the repo stays readable without learning a DI framework's rules. Trade-off: more manual code, zero code generation.

## Read next

- [Navigation](/architecture/navigation/)
- [Architecture Overview](/architecture/overview/)
