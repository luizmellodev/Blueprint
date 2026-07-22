---
title: "0007: Saga for Documentation Site"
summary: Swift static site generator. Markdown as source of truth, site as navigation layer.
status: accepted
date: 2026-07-22
order: 7
---
# 0007: Saga for Documentation Site

## Status

Accepted

## Context

After ~12 chapters, Markdown in `Documentation/` outgrew GitHub file browsing. Blueprint stays 100% Swift ecosystem; a JavaScript SSG would split the stack.

## Problem

Notion or CMS lock-in conflicts with "docs in git." Hand-written HTML duplicates content. GitHub-only rendering feels rough for a public reference project.

## Alternatives

1. **GitHub-rendered Markdown only:** zero build, weak IA
2. **Next.js / Astro:** great UX, wrong language
3. **Saga (Swift SSG):** Swift templates, Moon highlighting, same toolchain

## Decision

Markdown in `Documentation/Content/en/` remains authoritative. `Website/` runs Saga to emit static HTML. GitHub Actions builds on macOS; Vercel serves `Website/deploy/`.

## What worked

- Swim templates give type-checked HTML (top nav, sidebar, prev/next).
- SwiftTailwind integrated for docs UI without leaving the ecosystem.
- `./scripts/saga` wrapper fixes "run from repo root" ergonomics.
- ADRs and Architecture share one information architecture.

## What hurt

- Saga must run on **macOS** (CI cost, not Vercel-native build).
- Running `saga` from repo root without the script failed (`Package.swift` lives in `Website/`).
- Mermaid diagrams needed a build-time processor + unescaped init script (HTML entity escaping broke JS once).
- pt-BR structure exists but content is still placeholder.

## What we changed later

- Added `scripts/saga` and explicit `.executable` product in `Website/Package.swift`.
- Replaced landing-page home with docs-style Overview (user feedback: "looks like marketing, not documentation").
- Moved engineering topics from thin Concepts duplicates into full Architecture articles.
- Added `MermaidProcessor` to convert fenced blocks at build time.

## References

- [Documentation Site](/guides/documentation-site/) (quick start; full stack in [Website](/website/))
- [Future Directions](/guides/future-directions/)
- `Website/`, `Documentation/`
