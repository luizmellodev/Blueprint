# Blueprint Docs Site

Static documentation site for the Blueprint iOS architecture reference, built with [Saga](https://getsaga.dev/).

## Requirements

- Swift 6.0+
- macOS 14+
- [Saga CLI](https://getsaga.dev/docs/installation/)

```bash
brew install loopwerk/tap/saga
```

## Development

Run from the `Website/` folder (or use the helper script from the repo root):

```bash
# option 1 — from repo root
./scripts/saga dev --port 3000

# option 2 — from Website/
cd Website
saga dev --port 3000
```

Open [http://localhost:3000](http://localhost:3000). Saga watches `Documentation/` and `Sources/` for changes.

## Build

```bash
cd Website
saga build
```

Output goes to `Website/deploy/`.

## Content

Chapters live in [`../Documentation/`](../Documentation/):

```
Documentation/
├── index.md              # Home page
├── chapters/             # One .md per chapter
└── static/               # CSS and assets
```

Front matter example:

```markdown
---
title: Networking
summary: NetworkClient, Geoapify API, DTOs, and caching.
chapter: 6
status: done
---
```

Status values: `done`, `in-progress`, `coming-soon`.

## Deploy to Vercel

Saga requires macOS to build. Vercel serves static files — the build runs in GitHub Actions, not on Vercel's servers.

### One-time setup

1. Create a project at [vercel.com](https://vercel.com)
2. Install Vercel CLI: `npm i -g vercel`
3. Link the project: `cd Website && vercel link`
4. Add `VERCEL_TOKEN` to GitHub repository secrets ([create token](https://vercel.com/account/tokens))
5. Add `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` from `.vercel/project.json` after linking

### Automatic deploy

Push to `main` or `website` — GitHub Actions builds the site and deploys to Vercel.

### Manual deploy

```bash
cd Website
saga build
vercel deploy deploy --prod
```

## Project layout

```
Website/
├── Package.swift
├── Sources/Website/
│   ├── main.swift        # Saga pipeline
│   └── templates.swift   # HTML templates (Swim)
├── deploy/               # Generated output (gitignored)
└── vercel.json
```
