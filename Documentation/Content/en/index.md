---
title: Blueprint
slug: index
---
# Blueprint

A living handbook for modern SwiftUI architecture.

**Blueprint** is not a template, not a snippet collection, not a course. It is a public reference where every decision is documented and every technology exists to solve a real problem.

The example app is **Discover** — it explores Points of Interest (POIs) using the Geoapify API. The domain is deliberately generic so architecture stays in focus.

<div class="cta-row">
  <a class="btn btn-primary" href="/guides/getting-started/">Get started</a>
  <a class="btn btn-secondary" href="/architecture/">Architecture</a>
</div>

## Code explains HOW. Documentation explains WHY.

| Layer | Purpose |
|---|---|
| [Guides](/guides/) | Practical setup — clone, build, test, deploy |
| [Architecture](/architecture/) | Engineering decisions by layer |
| [Concepts](/concepts/) | Patterns used across the codebase |
| [ADRs](/decisions/) | Formal decision records |
| [Roadmap](/guides/roadmap/) | Chapter-by-chapter project evolution |

## Architecture at a glance

```
App Target (blueprint)
├── Navigation/       AppRoute, AppRouter, RouterProtocol
├── DI/               DIContainer, bundles, factories
├── Domain/           Entities, UseCases — zero framework imports
├── Data/             Repositories, DTOs, SwiftData, cache
└── Presentation/     Views, ViewModels, UIState

Packages/
├── DesignSystem/
└── Networking/
```

## Identity

> Blueprint is a public architecture reference built in the open. Each decision is documented, each chapter adds a layer, and each technology solves a real problem — not because it is trending.
