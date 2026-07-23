# Contributing to Blueprint

Blueprint is a **study project**, not a drop-in template. Contributions that explore trade-offs, document learnings, and stay honest about context are welcome.

## Before you start

1. Read the [site overview](https://ios-blueprint.vercel.app/) for how Discover is structured today.
2. Check [`Documentation/ROADMAP.md`](Documentation/ROADMAP.md) for planned chapters.
3. Remember: there is no single correct architecture. Explain **why** your change fits a given context.

## Ways to contribute

| Type | Example |
|---|---|
| **Chapter** | New feature with code + updates to `Documentation/Content/en/index.md` |
| **Documentation** | Fix inaccuracies, add diagrams, translate to pt-BR |
| **Experiment** | Coordinator, Fastlane, Remote Config in a focused PR |
| **Tests** | Coverage for ViewModels, SwiftData integration tests |

## Pull request format

### Title

Use a clear imperative sentence:

- `Add coverage gate to CI`
- `Wire mapView feature flag on Detail`
- `Document cache TTL in overview`

### Description

Include:

1. **What** changed
2. **Why** (problem and context)
3. **Trade-offs** considered
4. **How to test** (simulator steps or `xcodebuild test`)
5. **Docs updated** (list Markdown paths)

### Scope

- One logical change per PR when possible
- No drive-by refactors
- Match existing code style (see `CLAUDE.md`)
- Never commit `Config.xcconfig` or API keys

## Documentation rules

- **Markdown in `Documentation/`** is the source of truth
- App architecture lives under `Documentation/Content/en/architecture/`
- Home page: `Documentation/Content/en/index.md`
- Website meta-docs live under `Documentation/Content/en/website/`
- Run `./scripts/saga build` if you change content consumed by the site
- Avoid em dashes in prose; prefer commas or colons
- Only document what exists in code (or mark as planned)

## Local checks

```bash
# Lint
swiftlint lint

# Tests + coverage
xcodebuild test \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
  -enableCodeCoverage YES \
  -resultBundlePath /tmp/blueprint-coverage.xcresult \
  CODE_SIGNING_ALLOWED=NO

./scripts/check-coverage.sh /tmp/blueprint-coverage.xcresult 20

# Docs site
./scripts/saga build
```

CI runs SwiftLint, tests, and **fails if app target coverage drops below 20%** (70% is the long-term target).

## New files in Xcode

If you add Swift files, add them to the `blueprint` or `blueprintTests` target **inside Xcode** (do not rely on terminal for target membership).

## Questions

Open a GitHub Issue with context, alternatives you considered, and the scope you can implement.

---

Related: [Roadmap](Documentation/ROADMAP.md) · [Website README](Website/README.md)
