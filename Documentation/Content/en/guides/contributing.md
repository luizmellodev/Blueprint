---
title: Contributing
summary: How to open PRs, write decision journal ADRs, and run local quality checks.
order: 8
---
# Contributing

Blueprint is a **study project**, not a drop-in template. Contributions that explore trade-offs and document learnings are welcome.

See also the repo root [CONTRIBUTING.md](https://github.com/luizmellodev/Blueprint/blob/main/CONTRIBUTING.md).

## Before you start

1. [Future Directions](/guides/future-directions/) for open ideas
2. Relevant [Architecture](/architecture/overview/) article
3. Existing ADR if the area was decided before

## Pull request checklist

- [ ] One logical change per PR when possible
- [ ] Tests added or updated (`⌘U` or `xcodebuild test`)
- [ ] Coverage stays at or above **70%** on the `blueprint` app target
- [ ] Documentation updated in `Documentation/`
- [ ] No secrets committed (`Config.xcconfig` stays gitignored)
- [ ] SwiftLint passes (`swiftlint lint --strict`)

## PR description template

```markdown
## What
Brief summary of the change.

## Why
Problem and context.

## Trade-offs
Alternatives considered.

## How to test
Steps or commands.

## Docs
- [ ] Architecture / Guides / ADR updated (list paths)
```

## ADR format (Decision Journal)

Add or update `Documentation/Content/en/decisions/NNNN-topic.md`:

| Section | Purpose |
|---|---|
| **Context** | Situation when deciding |
| **Problem** | Pain to solve |
| **Alternatives** | Options considered |
| **Decision** | What we picked |
| **What worked** | Honest positives after shipping |
| **What hurt** | Surprises and limitations |
| **What we changed later** | Refactors and lessons |

ADRs complement [Architecture](/architecture/) articles. Architecture explains the pattern; ADRs capture the story and hindsight.

## Local checks

```bash
swiftlint lint --strict

xcodebuild test \
  -project blueprint.xcodeproj \
  -scheme blueprint \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
  -enableCodeCoverage YES \
  -resultBundlePath /tmp/blueprint-coverage.xcresult \
  CODE_SIGNING_ALLOWED=NO

./scripts/check-coverage.sh /tmp/blueprint-coverage.xcresult 70

./scripts/saga build
```

## Xcode note

Add new Swift files to the correct target inside Xcode.

## Related

- [Future Directions](/guides/future-directions/)
- [Running Tests](/guides/running-tests/)
- [CI/CD](/guides/ci-cd/)
- [ADRs](/decisions/)
