---
title: Documentation Site
summary: Quick start for local preview. Full stack docs live in the Website section.
order: 5
---
# Documentation Site

The website is **not** the documentation. It is a navigation layer over Markdown in `Documentation/`.

For the full guide (Saga, Tailwind, templates, Mermaid, deploy), read the **[Website](/website/)** section.

## Quick start

```bash
brew install loopwerk/tap/saga
./scripts/saga dev --port 3000
```

Open [http://localhost:3000](http://localhost:3000).

> Use `./scripts/saga` from the repo root. Running `saga` at the root fails because `Package.swift` lives in `Website/`.

## Build

```bash
./scripts/saga build
```

Output: `Website/deploy/`

## CI

Pushes and PRs run the **Website** workflow (build on macOS). See [Build & Preview](/website/deploy/) and [CI/CD](/guides/ci-cd/).

## Related

- [Website section](/website/)
- [ADR 0007: Saga for Documentation](/decisions/0007-saga-documentation-site/)
- `Website/README.md`
