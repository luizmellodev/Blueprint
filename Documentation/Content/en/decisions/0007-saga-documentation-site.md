---
title: "0007: Saga for Documentation Site"
summary: Swift static site generator, Markdown as source of truth, site as navigation layer.
status: accepted
date: 2026-07-22
order: 7
---
# 0007: Saga for Documentation Site

## Status

Accepted

## Context

After ~12 chapters, Blueprint needs a public documentation site. Content must stay in Markdown (git-friendly, diffable). The project stays 100% Swift ecosystem.

## Problem

Documentation in Notion/Wikipedia-style CMS creates vendor lock-in. Hand-written HTML duplicates content. JavaScript SSGs (Next.js, Astro) leave the Swift ecosystem.

## Alternatives

1. **GitHub-rendered Markdown only:** functional but not a polished reading experience
2. **Next.js / Astro:** great DX, wrong language
3. **Saga (Swift SSG):** Swift templates, Moon syntax highlight, same ecosystem

## Decision

Markdown in `Documentation/Content/en/` is the source of truth. Saga in `Website/` renders static HTML. Vercel serves pre-built output from GitHub Actions (macOS build).

## Consequences

**Positive:**
- Documentation and app share Swift ecosystem
- Type-safe HTML templates (Swim)
- Markdown stays authoritative, site is navigation only

**Negative:**
- Saga requires macOS to build, not Vercel-native
- Bilingual content requires duplicate folders or Saga i18n setup

## References

- [Documentation Site](/guides/documentation-site/)
- `Website/`, `Documentation/`
