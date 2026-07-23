---
title: CI/CD
summary: GitHub Actions pipeline with SwiftLint, tests, and coverage gate.
order: 4
---
# CI/CD

## Pipeline

Every pull request to `main` runs on `macos-15`:

1. **SwiftLint** (`swiftlint lint --strict`)
2. **Select Xcode** (`latest-stable` on the runner)
3. **Resolve iOS Simulator** (first available iPhone)
4. **Create `Config.xcconfig`** from `GEOAPIFY_API_KEY` secret
5. **`xcodebuild test`** with `-enableCodeCoverage YES`
6. **Coverage gate:** `./scripts/check-coverage.sh build/coverage.xcresult 20`

PRs fail if tests fail or if the **`blueprint` app target** line coverage drops below **20%**. The long-term target is **70%**; raise the CI threshold as test coverage grows.

```mermaid
flowchart LR
  PR[Pull request] --> L[SwiftLint strict]
  L --> T[xcodebuild test + coverage]
  T --> C[check-coverage.sh 20%]
  C --> OK[Merge allowed]
  L -->|fail| X[Block PR]
  T -->|fail| X
  C -->|fail| X
```

## Signing

CI uses `CODE_SIGNING_ALLOWED=NO`, simulator builds only, no provisioning profiles required.

## Coverage script

Local usage:

```bash
xcodebuild test \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' \
  -enableCodeCoverage YES \
  -resultBundlePath /tmp/blueprint-coverage.xcresult \
  CODE_SIGNING_ALLOWED=NO

./scripts/check-coverage.sh /tmp/blueprint-coverage.xcresult 20
```

## SwiftLint

Run locally before pushing:

```bash
swiftlint lint --strict
```

## Website CI

Documentation has a separate workflow (`.github/workflows/website.yml`):

- Builds Saga site on macOS
- Uploads `Website/deploy` as a CI artifact

See [Build & Preview](/website/deploy/) for local dev and build output.

## Related

- [Running Tests](/guides/running-tests/)
- [Contributing](/guides/contributing/)
- [Website section](/website/)
- [Documentation Site](/guides/documentation-site/)
- [API Key Setup](/guides/api-key-setup/)
