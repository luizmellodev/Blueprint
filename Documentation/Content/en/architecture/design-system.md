---
title: Design System
summary: Public design tokens in a Swift Package, spacing, typography, radius, color.
order: 2
---
# Design System

## The problem

Magic numbers scattered across views (`padding(16)`, `.font(.system(size: 17))`) diverge over time and break Dynamic Type.

## Why a Swift Package

Tokens in a dedicated package expose a small public API, prevent the app target from becoming a UI constants dump, and can be previewed independently.

## Alternatives considered

| Approach | Verdict |
|---|---|
| Extensions on `CGFloat` | No compile boundary |
| Asset catalog colors only | No spacing/typography |
| **Local Swift Package** | ✅ Chosen |

## Trade-offs

- **Pro:** Single source of truth for visual language
- **Pro:** Semantic tokens scale with Dynamic Type
- **Con:** Extra package to maintain for a small app

## How Blueprint implements it

| Token | Purpose |
|---|---|
| `DSSpacing` | Padding and gaps |
| `DSTypography` | Semantic font styles |
| `DSRadius` | Corner radii |
| `DSColor` | Semantic colors |

`SkeletonCardView` and `ShimmerModifier` live here as reusable loading primitives.

```mermaid
flowchart LR
  subgraph Package["DesignSystem package"]
    T[DSSpacing · DSTypography · DSRadius · DSColor]
    M[ShimmerModifier · SkeletonStyle]
  end

  subgraph App["Presentation views"]
    H[HomeView · POICardView]
    D[DetailView · DetailRowView]
    S[SkeletonCardView]
  end

  T --> H
  T --> D
  M --> S
```

- `Packages/DesignSystem/Sources/DesignSystem/Tokens/`
- `Packages/DesignSystem/Sources/DesignSystem/Modifiers/ShimmerModifier.swift`

## Further reading

- [Accessibility](/architecture/accessibility/)
