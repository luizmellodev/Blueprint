---
title: Content Model
summary: Frontmatter fields, folder conventions, and SiteCatalog sidebar navigation.
order: 3
---
# Content Model

Markdown files in `Documentation/Content/en/` are the **source of truth**. The website never edits content at runtime; it only renders what is in git.

## Article frontmatter

Every guide, architecture article, concept, and website doc uses:

```yaml
---
title: MVVM
summary: Views, ViewModels, and UIState enums.
order: 2
---
```

| Field | Required | Used for |
|---|---|---|
| `title` | Yes | Page `<h1>`, sidebar label, browser tab |
| `summary` | No | Lead paragraph and section index tiles |
| `order` | No | Sort order in lists and sidebar |

## ADR frontmatter

```yaml
---
title: "0007: Saga for Documentation Site"
summary: Swift static site generator.
status: accepted
date: 2026-07-22
order: 7
---
```

| Field | Required | Used for |
|---|---|---|
| `status` | Yes | Badge (Accepted, Proposed, Deprecated) |
| `date` | No | Badge next to status |

## Home page

`index.md` uses `slug: index` in frontmatter and renders through `renderHome` without section navigation context.

## SiteCatalog (sidebar)

Saga generates pages from **folders**. The sidebar also needs a **catalog** so links appear even before you remember the URL structure.

`Website/Sources/Website/SiteCatalog.swift` defines:

```swift
enum DocSection: String, CaseIterable {
  case guides, architecture, concepts, decisions, website
}

struct SiteEntry {
  let section: DocSection
  let slug: String
  let title: String
  let order: Int
}
```

When you add a new article:

1. Create the `.md` file in the correct folder
2. Add a matching `SiteEntry` row (section + slug must match the filename)

If you skip step 2, the page builds and is reachable by URL, but the sidebar will not list it.

## URL rules

Saga emits clean URLs configured in `Website/vercel.json`:

```json
{
  "cleanUrls": true,
  "trailingSlash": true
}
```

| File | URL |
|---|---|
| `guides/getting-started.md` | `/guides/getting-started/` |
| `architecture/overview.md` | `/architecture/overview/` |
| `guides/index.html` (list writer) | `/guides/` |

## Cross-linking

Link between articles with root-relative paths:

```markdown
See [Dependency Injection](/architecture/dependency-injection/).
```

These work locally and in production because every page is static HTML with the same path structure.

## Static assets

Place files under `Documentation/Content/en/static/`. Saga copies them to `deploy/static/`.

Tailwind output (`output.css`) is generated, not hand-edited.

## pt-BR (planned)

`Documentation/Content/pt-BR/` exists as a placeholder. A future Saga registration could mirror the `en` pipeline with a `/pt-BR/` prefix.

## Next

[Templates & Theme](/website/templates-and-theme/): docs shell, sidebar, and prose layout.
