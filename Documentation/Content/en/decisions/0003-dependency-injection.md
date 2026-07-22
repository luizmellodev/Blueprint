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

Discover's object graph grows with each chapter, networking, location, persistence, feature flags, multiple screens.

## Problem

Singletons and service locators hide dependencies. DI frameworks add magic that obscures the learning goal.

## Alternatives

1. **Swinject / Factory:** powerful, runtime resolution
2. **Service locator:** global access, hidden deps
3. **DIContainer + bundles + factories:** explicit, compile-time

## Decision

Single `DIContainer` at app launch. Dependencies grouped in bundles (`POIDependencies`, etc.). One factory per screen.

## Consequences

**Positive:**
- Entire graph readable in one place
- Jump-to-definition works everywhere
- No runtime resolution failures

**Negative:**
- Manual wiring when adding screens
- Container grows, mitigated by bundles

## References

- [Dependency Injection](/architecture/dependency-injection/)
- `blueprint/DI/`
