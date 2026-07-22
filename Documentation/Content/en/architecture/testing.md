---
title: Testing
summary: Swift Testing, protocol mocks, and what to test at each layer.
order: 7
---
# Testing

## The problem

Untested ViewModels regress silently. Testing UI with XCTest UI tests is slow and brittle for business logic.

## Why Swift Testing + protocol mocks

Dependencies are protocols. Tests inject mocks and assert state transitions with `@Test` and `#expect`.

## Alternatives considered

| Approach | Verdict |
|---|---|
| XCTest only | Works but verbose |
| UI tests for logic | ❌ Slow, brittle |
| **Swift Testing + mocks** | ✅ Chosen |

## Trade-offs

- **Pro:** Fast, focused, expressive syntax
- **Pro:** ViewModels tested in isolation
- **Con:** Mock maintenance as protocols evolve

## What to test

| Layer | Example |
|---|---|
| Mappers | `GeoapifyMapper.map` with valid/invalid DTOs |
| ViewModels | `.idle` → `.loading` → `.success` |
| ViewModels | Pagination, debounce, idle guard |
| DI | `DIContainer` creates factories without crash |

## What not to test (yet)

- SwiftUI layout snapshots
- Live URLSession calls
- SwiftData (in-memory container can come later)

## Related code

- `blueprintTests/`
- `blueprintTests/Mocks/`

## Further reading

- [Running Tests](/guides/running-tests/)
