---
title: "0003: Dependency Injection without a Framework"
summary: DIContainer, dependency bundles, and screen factories for explicit wiring.
status: accepted
date: 2026-03-15
order: 3
---
# 0003: Dependency Injection without a Framework

## Status

Accepted

## Context

Each chapter added dependencies: networking, location, SwiftData, feature flags, second screen. Singletons were unacceptable for a project that teaches testability.

## Problem

Service locators hide dependencies. DI frameworks (Swinject, Factory) solve scale but obscure the graph for learners jumping into the repo.

## Alternatives

1. **Swinject / Factory:** less boilerplate, runtime resolution
2. **Service locator:** global access
3. **DIContainer + bundles + factories:** explicit compile-time wiring

## Decision

One `@MainActor DIContainer` at launch. Bundles group dependencies by concern. `HomeFactory` and `DetailFactory` assemble screens.

## What worked

- Entire object graph traceable from `DIContainer.swift` in minutes.
- Bundles prevented a flat 200-line container when POI, persistence, and flags arrived.
- Factories encapsulate "what does Home need?" without Views knowing repository types.
- `DIContainerTests` smoke-test that wiring does not crash.

## What hurt

- Manual wiring every time a screen or dependency appears.
- `HomeFactory` already receives `FeatureFlagDependencies` but does not use it yet (placeholder for `.categoryFilter`).
- `@MainActor` container means tests must run on main actor (acceptable, but worth documenting).

## What we changed later

- Split flat container into bundles after chapter 5 (refactor, not rewrite).
- Considered Factory library; kept manual wiring for teaching clarity ([Future Directions](/guides/future-directions/)).

## References

- [Dependency Injection](/architecture/dependency-injection/)
- `blueprint/DI/`
