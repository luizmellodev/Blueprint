---
title: Logging
summary: OSLog categories via AppLogger. No print() in production paths.
order: 2
---
# Why Structured Logging?

Debug prints disappear in production and cannot be filtered by subsystem. Blueprint uses **OSLog** with named categories.

## What problem does this solve?

When cache misses or persistence fails, you need searchable logs in Console.app without spamming every layer.

## Why this solution?

`AppLogger` defines categories used in code today:

| Category | Used in |
|---|---|
| `cache` | `POICacheService` hit/miss/save |
| `persistence` | SwiftData operations |
| `location` | CoreLocation flow |

Network logging lives inside `URLSessionNetworkClient` in the Networking package.

## Alternatives

| Approach | Verdict |
|---|---|
| `print()` | Rejected: no levels, no filtering |
| Third-party logger | Rejected: unnecessary dependency |
| **OSLog + categories** | Chosen |

## Trade-offs

- **Pro:** Free, integrated with Instruments
- **Pro:** Privacy annotations possible per log
- **Con:** Verbose API compared to `print`
- **Con:** Not all layers log equally yet

## How Blueprint implements it

```swift
Logger.cache.info("Cache miss")
```

Filter Console by subsystem/category when debugging cache without noise from location.

## Related code

- `blueprint/Core/Logging/AppLogger.swift`
- `blueprint/Data/Cache/POICacheService.swift`
- `Packages/Networking/Sources/Networking/URLSessionNetworkClient.swift`

## Further reading

- [Caching](/architecture/caching/)
- [Performance](/architecture/performance/)
