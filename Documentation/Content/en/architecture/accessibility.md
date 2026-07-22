---
title: Accessibility
summary: Dynamic Type, VoiceOver, skeleton loading, and async placeholders.
order: 8
---
# Accessibility

## The problem

Apps built without accessibility from the start require expensive retrofitting. Fixed font sizes and spinner-only loading states exclude users.

## Why accessibility as default

Design System tokens use semantic styles. POI cards expose composed VoiceOver labels. Skeleton loading provides immediate structure for all users.

## Alternatives considered

| Approach | Verdict |
|---|---|
| Accessibility audit before release | ❌ Too late |
| Fixed font sizes | ❌ Breaks Dynamic Type |
| **Semantic tokens + composed labels** | ✅ Chosen |

## Trade-offs

- **Pro:** Inclusive from day one
- **Pro:** Skeleton cards prevent layout shift (helps everyone)
- **Con:** Slightly more code per interactive element

## How Blueprint implements it

- **Dynamic Type:** `DSTypography` tokens, no fixed point sizes
- **VoiceOver:** `.accessibilityElement(children: .combine)` on POI cards
- **Skeleton loading:** `SkeletonCardView` instead of centered spinner on first load
- **Inline placeholders:** DetailView shows row placeholders while async data loads

## Related code

- `blueprint/Presentation/Views/Home/HomeView.swift`
- `blueprint/Presentation/Views/Detail/DetailView.swift`
- `Packages/DesignSystem/Sources/DesignSystem/Modifiers/ShimmerModifier.swift`

## Further reading

- [Design System](/architecture/design-system/)
- [Observation](/concepts/observation/)
