---
title: CI/CD
summary: GitHub Actions pipeline — build, test, and Config.xcconfig from secrets.
order: 4
---
# CI/CD

## Pipeline

Every pull request runs on `macos-latest`:

1. Checkout
2. Select Xcode 16.3
3. Create `Config.xcconfig` from `GEOAPIFY_API_KEY` secret
4. `xcodebuild build` (iOS Simulator)
5. `xcodebuild test` (iOS Simulator)

## Signing

CI uses `CODE_SIGNING_ALLOWED=NO` — simulator builds only, no provisioning profiles required.

## SwiftLint

Run locally before pushing:

```bash
swiftlint lint
```

## Website CI

Documentation has a separate workflow (`.github/workflows/website.yml`):

- Builds Saga site on macOS
- Deploys static output to Vercel

## Related

- [Documentation Site](/guides/documentation-site/)
- [API Key Setup](/guides/api-key-setup/)
