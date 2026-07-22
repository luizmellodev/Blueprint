---
title: CI/CD
summary: GitHub Actions, SwiftLint, and automated builds.
chapter: 10
status: done
---
# CI/CD

Every pull request runs through GitHub Actions on macOS.

## Pipeline

1. Checkout
2. Create `Config.xcconfig` from secrets
3. Build the app
4. Run tests

```yaml
xcodebuild build \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

SwiftLint runs locally and can be added to CI. API keys never enter the repository — they come from GitHub Secrets at build time.
