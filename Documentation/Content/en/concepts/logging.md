---
title: Logging
summary: OSLog with subsystem and category — not print().
order: 6
---
# Logging

## The problem

`print()` always evaluates strings, cannot be filtered in Console.app, and has no log levels.

## Why OSLog

```swift
extension Logger {
    private static let subsystem = "dev.luizmello.blueprint"
    static let cache = Logger(subsystem: subsystem, category: "cache")
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
}
```

Filter Console by category `cache` when debugging cache issues — other subsystems stay silent.

## One logger per concern

| Logger | Used by |
|---|---|
| `Logger.cache` | POICacheService |
| `Logger.persistence` | FavoritesRepository |
| `Logger.location` | LocationService |

## Related code

- `blueprint/Core/Logging/AppLogger.swift`

## Further reading

- [Performance](/architecture/performance/)
