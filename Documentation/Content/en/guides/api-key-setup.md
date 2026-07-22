---
title: API Key Setup
summary: Inject Geoapify keys via xcconfig and Info.plist without hardcoding secrets.
order: 2
---
# API Key Setup

## The problem

Discover calls Geoapify on every POI fetch. The API key must be available at runtime but **never** committed to git.

## The solution

```
Config.xcconfig (gitignored)
  └─ GEOAPIFY_API_KEY = your_key
       ↓
Supporting/Info.plist
  └─ GeoapifyAPIKey = $(GEOAPIFY_API_KEY)
       ↓
Secrets.swift
  └─ Bundle.main.infoDictionary["GeoapifyAPIKey"]
```

## Local setup

```bash
cp Config.xcconfig.sample Config.xcconfig
```

```xcconfig
GEOAPIFY_API_KEY = your_api_key_here
```

## CI setup

GitHub Actions generates the file from secrets:

```yaml
- name: Create Config.xcconfig
  env:
    GEOAPIFY_API_KEY: ${{ secrets.GEOAPIFY_API_KEY }}
  run: echo "GEOAPIFY_API_KEY = $GEOAPIFY_API_KEY" > Config.xcconfig
```

## Code reference

- `Supporting/Info.plist`
- `blueprint/Secrets.swift`
- `Config.xcconfig.sample`

## Related

- [ADR 0006: xcconfig for API Keys](/decisions/0006-xcconfig-api-keys/)
- [Networking](/architecture/networking/)
