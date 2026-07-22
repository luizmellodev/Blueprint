---
title: Deploying Documentation
summary: Saga static site, Markdown chapters, and Vercel deploy.
chapter: 12
status: in-progress
---
# Deploying Documentation

This site is the documentation. It is built with [Saga](https://getsaga.dev/), a Swift static site generator.

## How it works

```
Documentation/chapters/*.md  →  Saga (Swift)  →  Website/deploy/
```

Chapters are plain Markdown with front matter. Swift templates render HTML with syntax highlighting via Moon.

## Local development

```bash
cd Website
saga dev --port 3000
```

## Deployment

The site deploys to Vercel via GitHub Actions. Saga requires macOS to build — Vercel serves the pre-built static output.
