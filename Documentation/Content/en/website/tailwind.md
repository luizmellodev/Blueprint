---
title: Tailwind CSS
summary: SwiftTailwind compiles utility CSS at build time. Typography plugin for prose articles.
order: 5
---
# Tailwind CSS

Blueprint uses [SwiftTailwind](https://github.com/loopwerk/SwiftTailwind) to compile Tailwind **during the Saga build**, not via Node.js in a separate terminal.

## Why SwiftTailwind?

| Approach | Verdict |
|---|---|
| CDN Tailwind in browser | Rejected: no purge, no typography plugin control |
| npm + postcss in CI | Rejected: second toolchain (Node) for a Swift project |
| **SwiftTailwind in Saga hook** | Chosen: one `saga build` step produces HTML + CSS |

## input.css

`Documentation/Content/en/static/input.css`:

```css
@import "tailwindcss";
@plugin "@tailwindcss/typography";

@source "../../../../Website/Sources/Website/**/*.swift";
@source "../**/*.md";

@theme {
  --font-sans: -apple-system, BlinkMacSystemFont, "SF Pro Text", ...;
  --color-brand-500: #2563eb;
}
```

| Directive | Purpose |
|---|---|
| `@import "tailwindcss"` | Tailwind v4 entry |
| `@plugin "@tailwindcss/typography"` | `prose` classes for article body |
| `@source ...swift` | Scan templates and Theme for class names |
| `@source ...md` | Scan Markdown for arbitrary classes (rare) |
| `@theme` | Custom fonts and brand colors |

## Build integration

In `main.swift`:

```swift
let tailwind = SwiftTailwind(version: "4.2.1")

try await tailwind.run(
  input: "../Documentation/Content/en/static/input.css",
  output: "../Documentation/Content/en/static/output.css",
  options: .minify
)
```

The `beforeRead` hook runs Tailwind when Swift sources change. The `afterWrite` hook copies `output.css` to `deploy/static/output.css`.

Templates reference the hashed URL:

```swift
link(href: Saga.hashed("/static/output.css"), rel: "stylesheet")
```

`Saga.hashed` cache-busts when CSS content changes.

## Prose styling

Article bodies use Tailwind Typography:

```swift
static let prose = """
  prose prose-zinc max-w-3xl dark:prose-invert \
  prose-headings:scroll-mt-20 ...
  """
```

Applied on `<article class="...">` wrapping Markdown output.

## Custom components in CSS

Mermaid containers get extra rules in `@layer components` inside `input.css` (borders, dark mode, wide diagrams).

## Local workflow

1. Edit `Theme.swift` or `input.css`
2. Run `./scripts/saga dev`
3. SwiftTailwind recompiles on rebuild; browser refresh shows changes

## Next

[Mermaid Diagrams](/website/mermaid/): build-time processor and client init.
