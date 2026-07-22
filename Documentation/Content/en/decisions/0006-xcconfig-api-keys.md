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

Geoapify requires a key on every request. Contributors clone a public repo; keys must never land in git. CI needs the same key from GitHub Secrets.

## Problem

Hardcoded keys leak in history. Raw environment variables do not populate `Bundle.main` without build glue. Native Birds uses Firebase Remote Config; Blueprint chose a simpler local-dev path first.

## Alternatives

1. **Hardcode in Secrets.swift:** rejected
2. **Environment variables only:** awkward in Xcode UI
3. **xcconfig → Info.plist → Bundle:** standard iOS pattern
4. **Remote Config at runtime:** planned v0.15

## Decision

Gitignored `Config.xcconfig` defines `GEOAPIFY_API_KEY`. `Supporting/Info.plist` injects into bundle. `Secrets.swift` reads at runtime.

## What worked

- Clone → copy sample → build is easy to document.
- CI writes xcconfig from `GEOAPIFY_API_KEY` secret in one step.
- Same pattern scales to staging/production xcconfig files.

## What hurt

- **First implementation failed:** custom `INFOPLIST_KEY_*` in xcconfig alone did not appear in generated Info.plist when `GENERATE_INFOPLIST_FILE = YES`. Xcode silently ignored the custom key.
- Keys in client apps are always extractable from the bundle (not a Blueprint-specific flaw).
- Onboarding friction: new contributors hit empty `apiKey=` until xcconfig is configured.

## What we changed later

- Added partial `Supporting/Info.plist` with `GeoapifyAPIKey = $(GEOAPIFY_API_KEY)` and set `INFOPLIST_FILE` in project settings (required fix, not optional polish).
- Documented the failure in [API Key Setup](/guides/api-key-setup/) so others skip the trap.

## References

- [API Key Setup](/guides/api-key-setup/)
- [Networking](/architecture/networking/)
- `Supporting/Info.plist`, `blueprint/Secrets.swift`
