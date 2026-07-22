---
title: Modularization
summary: Local Swift Packages and dependency boundaries.
chapter: 2
status: done
---
# Modularization

Blueprint modularizes with Swift Packages from day one instead of growing a monolithic target.

## Packages

```
Packages/
├── DesignSystem/   # Tokens, typography, spacing
└── Networking/     # NetworkClient protocol + URLSession implementation
```

## Why packages early

- **Compile-time boundaries** — a module can't import what it shouldn't
- **Reusability** — DesignSystem has zero app dependencies
- **Teaching** — each package is a self-contained lesson

The app target owns navigation, DI, and feature wiring. Shared infrastructure lives in packages.
