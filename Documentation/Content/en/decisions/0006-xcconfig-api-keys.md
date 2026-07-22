---
title: "0006: xcconfig for API Keys"
summary: Inject Geoapify API keys via Config.xcconfig and Supporting/Info.plist.
status: accepted
date: 2026-04-10
order: 6
---
# 0006: xcconfig for API Keys

## Status

Accepted

## Context

Geoapify requires an API key on every request. Keys must not be committed. CI needs keys from GitHub Secrets.

## Problem

Hardcoded keys leak in git history. Environment variables don't integrate cleanly with iOS bundle Info.plist without build-step glue.

## Alternatives

1. **Hardcode in Secrets.swift** — ❌ committed to git
2. **Environment variables only** — awkward in Xcode
3. **xcconfig → Info.plist → Bundle** — standard iOS pattern

## Decision

`Config.xcconfig` (gitignored) defines `GEOAPIFY_API_KEY`. `Supporting/Info.plist` references `$(GEOAPIFY_API_KEY)`. `Secrets.swift` reads from `Bundle.main`.

Note: custom `INFOPLIST_KEY_*` in xcconfig alone does not work — Xcode ignores user-defined keys when generating Info.plist. A partial Info.plist file is required.

## Consequences

**Positive:**
- Keys out of source control
- CI generates xcconfig from secrets
- Same pattern works for staging/production keys

**Negative:**
- Key still visible in app bundle at runtime (all client-side keys are)
- Requires manual Config.xcconfig setup after clone

## References

- [API Key Setup](/guides/api-key-setup/)
- `Supporting/Info.plist`, `blueprint/Secrets.swift`
