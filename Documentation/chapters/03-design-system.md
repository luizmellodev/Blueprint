---
title: Design System
summary: DSSpacing, DSTypography, and shared visual tokens.
chapter: 3
status: done
---
# Design System

Visual consistency comes from a local Swift Package with public design tokens.

## Tokens

| Token | Purpose |
|---|---|
| `DSSpacing` | Padding and gaps |
| `DSTypography` | Font styles |
| `DSRadius` | Corner radii |
| `DSColor` | Semantic colors |

## Usage

Views import `DesignSystem` and use tokens instead of magic numbers:

```swift
import DesignSystem

VStack(spacing: DSSpacing.md) {
    Text("Discover")
        .font(DSTypography.title)
}
```

Keeping tokens in a package prevents the app layer from becoming a dumping ground for UI constants.
