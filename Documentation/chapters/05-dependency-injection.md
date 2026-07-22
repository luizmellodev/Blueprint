---
title: Dependency Injection
summary: DIContainer, dependency bundles, and screen factories.
chapter: 5
status: done
---
# Dependency Injection

Blueprint uses explicit DI without a third-party framework.

## Structure

```
DI/
├── DIContainer.swift
├── Core/
│   ├── NetworkDependencies
│   ├── POIDependencies
│   └── ...
└── Factories/
    ├── HomeFactory
    └── DetailFactory
```

## Why this pattern

- **`DIContainer`** — root assembler, created once at app launch
- **Dependency bundles** — group related dependencies per concern
- **Factories** — one factory per screen, wires ViewModel + dependencies

Everything is traceable. No magic `@Inject` attributes, no runtime reflection.
