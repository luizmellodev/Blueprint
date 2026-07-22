---
title: Documentation Site
summary: Build and preview the Saga documentation site locally.
order: 5
---
# Documentation Site

The website is **not** the documentation — it is a beautiful way to navigate Markdown files in `Documentation/`.

## Requirements

```bash
brew install loopwerk/tap/saga
```

## Development

```bash
# from repo root
./scripts/saga dev --port 3000

# or from Website/
cd Website && saga dev --port 3000
```

Open [http://localhost:3000](http://localhost:3000).

> Run saga from `Website/` or via `./scripts/saga`. Running from the repo root without the script fails — `Package.swift` lives inside `Website/`.

## Build

```bash
./scripts/saga build
```

Output: `Website/deploy/`

## Content structure

```
Documentation/
├── ROADMAP.md
└── Content/
    ├── en/
    │   ├── guides/
    │   ├── architecture/
    │   ├── concepts/
    │   └── decisions/
    └── pt-BR/          (coming soon)
```

## Deploy

Saga requires macOS. Vercel serves pre-built static files via GitHub Actions. See `Website/README.md`.

## Related

- [ADR 0007: Saga for Documentation](/decisions/0007-saga-documentation-site/)
