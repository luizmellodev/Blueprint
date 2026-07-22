---
title: Accessibility
summary: Dynamic Type, VoiceOver labels, and skeleton loading.
chapter: 9
status: in-progress
---
# Accessibility

Discover is built with accessibility as a default, not an afterthought.

## Decisions

- **Dynamic Type** — no fixed font sizes; use semantic styles and DesignSystem tokens
- **Composed labels** — POI cards expose a single accessibility element with a meaningful label
- **Skeleton over spinners** — immediate visual feedback without layout shift

```swift
.accessibilityElement(children: .combine)
.accessibilityLabel("\(poi.name), \(poi.category.displayName)")
```

This chapter is still being expanded as accessibility patterns are added across the app.
