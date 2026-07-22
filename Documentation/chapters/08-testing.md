---
title: Testing
summary: Swift Testing, mocks, and ViewModel unit tests.
chapter: 8
status: done
---
# Testing

Blueprint uses Swift Testing (`@Test`, `#expect`) instead of XCTest.

## Test structure

```
blueprintTests/
├── Mocks/
├── HomeViewModelTests.swift
├── GeoapifyMapperTests.swift
└── DIContainerTests.swift
```

## Patterns

- **Mocks implement protocols** — `MockPOIRepository`, `MockLocationService`
- **ViewModels tested in isolation** — dependencies injected via init
- **Pure functions tested directly** — mappers and UseCases need no mocks

```swift
@Test
func mapsValidDTO() {
    let poi = GeoapifyMapper.map(dto: validDTO)
    #expect(poi?.name == "Museu Paulista")
}
```

No UI tests for business logic — keep tests fast and focused.
