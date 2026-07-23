---
title: Blueprint
slug: index
---

## What this is

**Blueprint** is a public iOS architecture **study project**. Code and notes written while learning, not a shipped product or a copy-paste template.

The repo holds **Discover** (SwiftUI app) and **this site** (Markdown → Saga → static HTML).

Adapted from [Native Birds](https://github.com/spanesso/native-birds) by Sebastian Panesso.

## Getting started

**Requirements:** Xcode 16+, iOS 17+ simulator, free [Geoapify API key](https://www.geoapify.com/).

```bash
git clone https://github.com/luizmellodev/Blueprint.git
cd Blueprint
cp Config.xcconfig.sample Config.xcconfig
```

Set your key in `Config.xcconfig` (gitignored). Open `blueprint.xcodeproj`, pick a simulator, ⌘R.

## Discover

**Discover** is the SwiftUI example app: nearby places via Geoapify, with a **Discover** tab (POI list, city search, pagination), a **Favorites** tab (SwiftData), and a shared **Detail** screen.

## Architecture

Discover follows **[Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)**. The pages below describe **how I built it** in this repo, not how every app should be built.

See **[Architecture Overview](/architecture/overview/)** first.

| Topic | Page |
|---|---|
| MVVM on each screen | [MVVM](/architecture/mvvm/) |
| Entities & Use Cases | [Domain](/architecture/domain/) |
| Repositories vs Services | [Repositories & Services](/architecture/repositories-and-services/) |
| HTTP & DTOs | [Networking](/architecture/networking/) |
| Favorites on disk | [SwiftData](/architecture/swiftdata/) |
| DIContainer & factories | [Dependency Injection](/architecture/dependency-injection/) |
| AppRoute & stacks | [Navigation](/architecture/navigation/) |
| Swift Packages | [Modularization](/architecture/modularization/) |

## Roadmap

Chapters v0.1–v0.12 shipped (setup through docs site). Planned: deep links, MapKit, Remote Config, DocC, pt-BR.

[`Documentation/ROADMAP.md`](https://github.com/luizmellodev/Blueprint/blob/main/Documentation/ROADMAP.md)

## This site

Built with [Saga](https://getsaga.dev/). Meta-docs: [Website](/website/) section.
