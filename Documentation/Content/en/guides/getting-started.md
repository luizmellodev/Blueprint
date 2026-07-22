---
title: Getting Started
summary: Clone, configure API keys, build Discover, and understand the repository layout.
order: 1
---
# Getting Started

## Prerequisites

- Xcode 16+
- iOS 17+ simulator or device
- Free [Geoapify API key](https://www.geoapify.com/) (3,000 requests/day, no credit card)

## Clone and configure

```bash
git clone https://github.com/luizmellodev/Blueprint.git
cd Blueprint
cp Config.xcconfig.sample Config.xcconfig
```

Edit `Config.xcconfig` and replace `your_api_key_here` with your Geoapify key. This file is gitignored — never commit it.

## Build and run

1. Open `blueprint.xcodeproj` in Xcode
2. Select an iOS 17+ simulator
3. Press ⌘R

Discover loads nearby POIs based on simulator location (defaults to São Paulo if location permission is denied).

## Repository layout

```
Blueprint/
├── blueprint/              App target — Discover
├── Packages/               Local Swift Packages
├── Documentation/          Source of truth (Markdown)
├── Website/                Saga static site generator
├── Supporting/             Info.plist partial (API key injection)
└── Config.xcconfig         Local secrets (gitignored)
```

## What to read first

1. [Modularization](/architecture/modularization/) — why packages from day one
2. [Navigation](/architecture/navigation/) — type-safe routing
3. [Dependency Injection](/architecture/dependency-injection/) — wiring without frameworks

## Related

- [API Key Setup](/guides/api-key-setup/)
- [Running Tests](/guides/running-tests/)
- [Roadmap](/guides/roadmap/)
