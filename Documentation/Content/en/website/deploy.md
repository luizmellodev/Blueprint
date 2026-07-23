---
title: Build & Preview
summary: Local dev, production build, GitHub Actions, and Vercel.
order: 2
---
# Build & Preview

Saga runs on **macOS**. Output is plain static files in `Website/deploy/`. Vercel (or any CDN) only serves those files; it does not run Saga.

Tooling intro: [Site Overview](/website/overview/).

## Local preview

**Requirements:** Swift 6+, macOS 14+, Saga CLI.

```bash
brew install loopwerk/tap/saga
./scripts/saga dev --port 3000
```

Open [http://localhost:3000](http://localhost:3000).

Saga watches:

- `Documentation/Content/en/` (Markdown)
- `Website/Sources/Website/` (Swift templates, pipeline)

Tailwind recompiles when Swift or `input.css` change. Markdown-only edits rebuild pages without re-running Tailwind (see `beforeRead` guard in `main.swift`).

## Production build

```bash
./scripts/saga build
```

Equivalent to `cd Website && saga build`. Output: `Website/deploy/`.

Sanity check:

```bash
open Website/deploy/index.html
```

Or serve the folder with any static file server.

## Generated vs committed

| Output | Location | In git? |
|---|---|---|
| HTML pages | `Website/deploy/` | No |
| Compiled CSS | `deploy/static/output.css` | No |
| Source Markdown | `Documentation/Content/en/` | Yes |
| Tailwind input | `static/input.css` | Yes |

Never commit `Website/deploy/`. Never rely on Vercel Git builds alone (folder is empty in the repo).

## CI (GitHub Actions)

Workflow: `.github/workflows/website.yml`

**Triggers:** changes to `Website/**`, `Documentation/**`, or the workflow file.

**Build job** (`macos-latest`):

1. Checkout
2. Restore cache (`Website/.build`, SwiftPM)
3. `swift build --product Website`
4. Run `.build/.../debug/Website`
5. Verify `Website/deploy/index.html`
6. Upload artifact (7 days)

**Deploy job** (push to `main` only):

1. Download artifact to `Website/deploy/`
2. Write `vercel.json`
3. `vercel deploy --prod` from `Website/deploy/`

CI skips Homebrew Saga. The compiled Swift executable is the build product.

iOS CI is separate and does not run for doc-only changes.

## Vercel setup

One-time:

1. Create a Vercel project
2. Add secrets: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`
3. **Settings → Build and Deployment → Ignored Build Step → Don't build anything**

| Setting | Value |
|---|---|
| Root Directory | empty |
| Output Directory | empty |
| Build Command | off |

Production deploys come **only** from GitHub Actions, not from Vercel Git on push.

**404 after merge?** A Vercel Git deploy without the Actions artifact uploads an empty site. Check the deployment was created by the Website workflow, not Git integration alone.

Manual deploy:

```bash
./scripts/saga build
cd Website/deploy
vercel deploy --prod
```

## URL shape

`vercel.json` in deploy output:

```json
{
  "cleanUrls": true,
  "trailingSlash": true
}
```

Example: `architecture/mvvm.md` → `/architecture/mvvm/`

## Troubleshooting

| Symptom | Fix |
|---|---|
| `saga: command not found` | `brew install loopwerk/tap/saga` |
| Build fails from repo root | `./scripts/saga build` |
| Sidebar missing new page | Add row to `SiteCatalog.swift` |
| Mermaid shows as code block | Rebuild; see [Implementation](/website/implementation/) |
| Tailwind classes missing | Edit `Theme.swift` or `input.css`, rebuild |
| Production 404 | Disable Vercel Git builds; deploy via Actions |

## Related

- [Site Overview](/website/overview/)
- [Implementation](/website/implementation/)
- `Website/README.md`
