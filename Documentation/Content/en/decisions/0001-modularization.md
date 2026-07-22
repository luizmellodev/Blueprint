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

Blueprint started as a teaching codebase. The reference project ([Native Birds](https://github.com/spanesso/native-birds)) already separated concerns; we wanted boundaries enforced by the compiler from day one, not after a painful refactor.

## Problem

In a single app target, anything can import anything. Domain types drift toward SwiftUI. Learners cannot *see* architecture, only read about it.

## Alternatives

1. **Single app target:** simplest, no boundaries
2. **Xcode frameworks:** familiar, heavier than SPM
3. **Local Swift Packages:** SPM-native, strict imports

## Decision

Extract **DesignSystem** and **Networking** as local packages. Keep Navigation, DI, and feature screens in the app target because they reference cross-layer types (`POI`, full object graph).

## What worked

- Import errors immediately teach dependency direction ("Domain cannot import DesignSystem tokens in wrong layer" becomes obvious in reviews).
- Packages rebuild incrementally; adding tokens to DesignSystem does not recompile every ViewModel file in isolation tests.
- Two packages were enough to demonstrate the pattern without drowning new readers in target management.

## What hurt

- More Xcode targets to maintain (scheme, test targets, package resolution).
- Navigation and DI **cannot** move to packages without awkward type erasure or duplicated models.
- Only two packages exist so far; the app target is still large. Feature modules (Home, Detail as packages) remain future work.

## What we changed later

- Nothing structural yet. [Future Directions](/guides/future-directions/) lists feature modules as a study path.
- Documentation grew faster than package count: most architecture articles still describe the app target.

## References

- [Modularization](/architecture/modularization/)
- `Packages/DesignSystem/`, `Packages/Networking/`
