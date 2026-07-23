---
title: Running Tests
summary: Swift Testing, mocks, code coverage, and running the test suite locally and in CI.
order: 3
---
# Running Tests

## Run in Xcode

1. Select the **blueprint** scheme
2. Enable coverage: **Product → Scheme → Edit Scheme → Test → Options → Gather coverage for: blueprint**
3. Press **⌘U**
4. Open **Report navigator → Coverage** to see line percentages

## Run from terminal

```bash
xcodebuild test \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' \
  -enableCodeCoverage YES \
  -resultBundlePath /tmp/blueprint-coverage.xcresult \
  CODE_SIGNING_ALLOWED=NO
```

## Read coverage from the result bundle

```bash
xcrun xccov view --report --only-targets /tmp/blueprint-coverage.xcresult
```

For file-level detail:

```bash
xcrun xccov view --report /tmp/blueprint-coverage.xcresult
```

## Coverage target

Blueprint follows the same quality bar as the [native-birds](https://github.com/spanesso/native-birds) reference project:

| Metric | Target |
|---|---|
| **App target (`blueprint`)** | **70%** line coverage (long-term goal) |
| **CI floor** | **20%** — enforced in GitHub Actions |

Coverage focuses on **Domain, UseCases, ViewModels, and mappers**. SwiftUI layout, live network, and SwiftData integration are out of scope for now.

## Test structure

```
blueprintTests/
├── Mocks/                          Protocol-based test doubles
├── Helpers/                        POI+Mock, GeocodingResult+Mock
├── GeoapifyMapperTests.swift
├── FetchNearbyPOIsUseCaseTests.swift
├── FetchPlaceDetailsUseCaseTests.swift
├── SearchLocationUseCaseTests.swift
├── HomeViewModelTests.swift
├── HomeViewModelPaginationTests.swift
├── HomeViewModelGeocodingTests.swift
└── DIContainerTests.swift
```

## Conventions

- ViewModels tested with mock UseCases and mock services
- UseCases tested with mock repository protocols
- Mappers tested as pure functions, no mocks needed
- Swift Testing (`@Test`, `#expect`), not XCTest
- `@MainActor` on test structs that touch ViewModels or `@MainActor` mocks

## Related

- [Testing Strategy](/architecture/testing/)
- [CI/CD](/guides/ci-cd/)
