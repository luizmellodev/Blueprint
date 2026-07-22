---
title: Running Tests
summary: Swift Testing, mocks, and running the test suite locally and in CI.
order: 3
---
# Running Tests

## Run in Xcode

Press **⌘U** with the `blueprint` scheme selected.

## Run from terminal

```bash
xcodebuild test \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

## Test structure

```
blueprintTests/
├── Mocks/                  Protocol-based test doubles
├── HomeViewModelTests.swift
├── GeoapifyMapperTests.swift
└── DIContainerTests.swift
```

## Conventions

- ViewModels tested with mock UseCases and mock services
- Mappers tested as pure functions — no mocks needed
- Swift Testing (`@Test`, `#expect`) — not XCTest

## Related

- [Testing Strategy](/architecture/testing/)
- [CI/CD](/guides/ci-cd/)
