---
title: Modularization
summary: Local Swift Packages for compile-time boundaries and reusable modules.
order: 1
---
# Modularization

## The problem

Monolithic app targets grow until every file can import everything. Dependency direction becomes a convention enforced by code review — not by the compiler.

## Why Swift Packages

Local packages provide **compile-time boundaries**. If `DesignSystem` cannot import `blueprint`, it cannot reference a ViewModel. The compiler enforces the rule.

## Alternatives considered

| Approach | Pros | Cons |
|---|---|---|
| Single target | Simplest start | No boundaries, slow rebuilds |
| Xcode frameworks | Familiar | Heavier, less SPM integration |
| **Swift Packages** | SPM-native, portable, strict imports | Initial setup cost |

## Trade-offs

- **Pro:** Boundaries are real, not documented-only
- **Pro:** Packages reusable across targets (widgets, extensions)
- **Con:** More targets to manage in Xcode
- **Con:** Navigation and DI stay in app target (they reference all features)

## How Blueprint implements it

```
Packages/
├── DesignSystem/     Tokens, typography, skeleton components
└── Networking/       NetworkClient protocol + URLSessionNetworkClient
```

What stays in the app target: Navigation (references `POI`), DI (wires full graph), feature screens.

## Related code

- `Packages/DesignSystem/`
- `Packages/Networking/`

## Further reading

- [ADR 0001: Modularization](/decisions/0001-modularization/)
- [Design System](/architecture/design-system/)
