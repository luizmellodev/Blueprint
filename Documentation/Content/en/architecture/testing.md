---
title: Testing
summary: Swift Testing with protocol mocks at UseCase and ViewModel layers.
order: 9
---
# Why Testing This Way?

Architecture only stays honest if tests can replace infrastructure. Blueprint tests **behavior at layer boundaries**, not SwiftUI pixel layout.

## What problem does this solve?

Untested ViewModels regress silently when pagination, debounce, or idle guards change. Testing through live Geoapify calls is flaky and burns API quota.

## Why this solution?

| Layer | Strategy |
|---|---|
| Mappers | Pure functions, fixture JSON |
| UseCases | Mock repository protocols |
| ViewModels | Mock use case + location protocols |
| DI | Smoke test container builds |

Swift Testing (`@Test`, `#expect`) is the framework in `blueprintTests/`.

## Alternatives

| Approach | Verdict |
|---|---|
| XCTest only | Works; Blueprint uses Swift Testing |
| UI tests for business logic | Rejected: slow, brittle |
| Live network integration tests | Rejected in CI for now |
| **Protocol mocks + Swift Testing** | Chosen |

## Trade-offs

- **Pro:** Fast tests, no simulator network
- **Pro:** Documents expected state transitions
- **Pro:** Mocks live beside tests in `blueprintTests/Mocks/`
- **Con:** Mocks drift if protocols change without test updates
- **Con:** SwiftData not integration-tested yet (noted gap)

## Architecture and coverage

Blueprint uses the same quality model as the [native-birds](https://github.com/spanesso/native-birds) reference:

- **Clean Architecture** with **protocol-driven boundaries**
- ViewModels depend on UseCase protocols, not Repositories
- UseCases depend on Repository protocols, not `URLSession` or SwiftData
- Tests swap mocks at those protocol seams

| Metric | Target |
|---|---|
| `blueprint` app target line coverage | **70%** |
| CI enforcement | Yes (`scripts/check-coverage.sh` in GitHub Actions) |

How to measure: [Running Tests](/guides/running-tests/).

```mermaid
flowchart LR
  T[@Test]
  VM[HomeViewModel]
  UC[FetchNearbyPOIsUseCaseProtocol]
  REPO[POIRepositoryProtocol]
  T --> VM
  VM -.->|mock| UC
  UC -.->|mock| REPO
```

## How Blueprint implements it

**Test files today**

| File | Covers |
|---|---|
| `GeoapifyMapperTests` | DTO → POI mapping |
| `FetchNearbyPOIsUseCaseTests` | UseCase + mock repository |
| `FetchPlaceDetailsUseCaseTests` | UseCase + mock repository |
| `SearchLocationUseCaseTests` | Geocoding use case |
| `HomeViewModelTests` | State transitions, idle guard |
| `HomeViewModelPaginationTests` | `loadMore`, `hasMore` |
| `HomeViewModelGeocodingTests` | Location search selection |
| `DIContainerTests` | Container constructs without crash |

**Example pattern**

`HomeViewModel` tests inject `MockFetchNearbyPOIsUseCase` and `MockLocationService` at protocol boundaries.

## What we do not test (yet)

- SwiftUI layout snapshots
- Live `URLSession` against Geoapify
- SwiftData persistence (in-memory container possible later)

## Related code

- `blueprintTests/`
- `blueprintTests/Mocks/`
- `blueprintTests/Helpers/`

## Further reading

- [Running Tests](/guides/running-tests/)
- [MVVM](/architecture/mvvm/)
- [Dependency Injection](/architecture/dependency-injection/)
