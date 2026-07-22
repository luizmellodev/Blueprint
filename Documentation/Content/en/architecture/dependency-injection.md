---
title: Dependency Injection
summary: DIContainer, dependency bundles, and screen factories — no DI framework.
order: 4
---
# Dependency Injection

## The problem

As dependencies grow, `init()` methods and singletons become untraceable. A missing dependency surfaces at runtime, not compile time.

## Why explicit DI without a framework

Blueprint's graph is known at compile time. Explicit wiring in `DIContainer` means jump-to-definition always works and there is no magic `@Inject`.

## Alternatives considered

| Approach | Verdict |
|---|---|
| Swinject / Factory | Powerful but opaque |
| Service locator | Hidden dependencies |
| **DIContainer + Factories** | ✅ Chosen |

## Trade-offs

- **Pro:** Fully traceable, no runtime resolution
- **Pro:** Bundles keep container readable as graph grows
- **Con:** Manual wiring when adding screens

## How Blueprint implements it

```
DI/
├── DIContainer.swift
├── Core/           NetworkDependencies, POIDependencies, ...
└── Factories/      HomeFactory, DetailFactory
```

Factories assemble ViewModels. Bundles group related dependencies per concern.

## Related code

- `blueprint/DI/DIContainer.swift`
- `blueprint/DI/Core/`
- `blueprint/DI/Factories/`

## Further reading

- [ADR 0003: Dependency Injection](/decisions/0003-dependency-injection/)
- [Use Cases](/concepts/use-cases/)
- [Feature Flags](/concepts/feature-flags/)
