---
title: "0001: Modularization with Swift Packages"
summary: Use local Swift Packages from day one for compile-time dependency boundaries.
status: accepted
date: 2026-03-01
order: 1
---
# 0001: Modularization with Swift Packages

## Status

Accepted

## Context

Blueprint aims to teach iOS architecture. A monolithic target makes it easy to violate layer boundaries — Domain importing SwiftUI, DTOs leaking into ViewModels.

## Problem

Without compile-time boundaries, dependency direction relies on convention and code review. Learners cannot see architecture enforced by the tools.

## Alternatives

1. **Single app target** — simplest, no boundaries
2. **Xcode frameworks** — heavier, less SPM-native
3. **Local Swift Packages** — SPM boundaries, portable modules

## Decision

Use local Swift Packages (`DesignSystem`, `Networking`) from project creation. Keep Navigation and DI in the app target.

## Consequences

**Positive:**
- Compiler enforces import boundaries
- Packages reusable across targets
- Teaches modularization as default, not refactor

**Negative:**
- More Xcode targets to manage
- Navigation cannot move to a package without losing type-safe routes across features

## References

- [Modularization](/architecture/modularization/)
- `Packages/DesignSystem/`, `Packages/Networking/`
