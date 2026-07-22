---
title: Feature Flags
summary: Type-safe FeatureFlag enum with swappable FeatureFlagServiceProtocol.
order: 4
---
# Feature Flags

## The problem

Hardcoded `if DEBUG` blocks and stringly-typed flag names cause typos and prevent gradual rollout.

## Why enum + protocol

```swift
enum FeatureFlag: String {
    case favorites
    case mapView
    case categoryFilter
}
```

`FeatureFlagServiceProtocol` allows local defaults today, Firebase Remote Config tomorrow — Views unchanged.

## Ship dark, enable gradually

1. Ship code behind disabled flag
2. Enable for internal testers
3. Roll out to 10% → 100%
4. Disable remotely if issues appear — no App Store release needed

## Related code

- `blueprint/Data/FeatureFlags/FeatureFlag.swift`
- `blueprint/Data/FeatureFlags/FeatureFlagService.swift`

## Further reading

- [Performance](/architecture/performance/)
