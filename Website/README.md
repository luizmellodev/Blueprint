# Blueprint Docs Site

Static documentation site for the Blueprint iOS architecture reference, built with [Saga](https://getsaga.dev/).

**Live:** [ios-blueprint.vercel.app](https://ios-blueprint.vercel.app)

## Requirements

- Swift 6.0+
- macOS 14+
- [Saga CLI](https://getsaga.dev/docs/installation/)

```bash
brew install loopwerk/tap/saga
```

## Development

Run from the `Website/` folder (or use the helper script from the repo root):

```bash
# option 1, from repo root
./scripts/saga dev --port 3000

# option 2, from Website/
cd Website
saga dev --port 3000
```

Open [http://localhost:3000](http://localhost:3000). Saga watches `Documentation/` and `Sources/` for changes.

## Build

```bash
cd Website
saga build
```

Output goes to `Website/deploy/`.

## Content structure

```
Documentation/
├── ROADMAP.md
└── Content/
    ├── en/
    │   ├── index.md
    │   ├── guides/
    │   ├── architecture/
    │   ├── concepts/
    │   ├── decisions/      ADRs
    │   ├── website/        Meta-docs about this site
    │   └── static/
    └── pt-BR/              Coming soon
```

Saga reads from `Documentation/Content/en/` and outputs to `Website/deploy/`.

## Site sections

| Section | URL | Purpose |
|---|---|---|
| Guides | `/guides/` | Practical setup |
| Architecture | `/architecture/` | Engineering decisions |
| Concepts | `/concepts/` | Cross-cutting patterns |
| ADRs | `/decisions/` | Formal decision records |
| Website | `/website/` | How this site is built (Saga, Tailwind, build) |

Meta-docs source: `Documentation/Content/en/website/`

## Deploy to Vercel

Saga requires macOS to build. Vercel serves static files, the build runs in GitHub Actions, not on Vercel's servers.

### One-time setup

1. Create a project at [vercel.com](https://vercel.com)
2. Install Vercel CLI: `npm i -g vercel@latest`
3. Build once locally, then link from the output folder: `./scripts/saga build && cd Website/deploy && vercel link`
4. Add `VERCEL_TOKEN` to GitHub repository secrets ([create token](https://vercel.com/account/tokens))
5. Add `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` from `Website/deploy/.vercel/project.json` after linking

### Vercel project settings (required for GitHub Actions)

The deploy job uploads pre-built files from CI. Saga runs in GitHub Actions, not on Vercel.

Go to [Project Settings → General](https://vercel.com/luizmellodev/blueprint/settings):

| Setting | Value |
|---|---|
| **Root Directory** | empty (`./`) |
| **Output Directory** | empty |
| **Build Command** | off / empty |
| **Install Command** | off / empty |
| **Ignored Build Step** | **Don't build anything** (Settings → Build and Deployment, not Git) |
| **Include files outside the root directory** | disabled (not needed) |

The banner **"Production Overrides: output directory deploy"** compares the last live deployment with current settings. It clears after the next successful production deploy.

The workflow uploads pre-built HTML from `Website/deploy/` with `vercel deploy --prod`. Keep Root Directory and Output Directory empty in project settings.

### Automatic deploy

The [Website workflow](https://github.com/luizmellodev/Blueprint/blob/main/.github/workflows/website.yml) runs on:

- **Push to `main`** when files change under `Website/`, `Documentation/`, or `.github/workflows/website.yml`
- **Pull requests** that touch those paths (build only, no production deploy)
- **Manual:** Actions → Website → Run workflow

Pushes that only change the root `README.md`, Swift sources, or other paths **do not** trigger this workflow. The iOS CI workflow is separate and uses its own path filters.

When it runs: `swift build` + run the `Website` executable on macOS (debug; fast enough for CI), then `vercel deploy --prod` from `Website/deploy/`.

GitHub Actions caches `Website/.build` (SPM compile output and Saga's `.build/saga-cache`) plus the SwiftPM download cache. The cache key follows `Package.resolved` and `Package.swift`, so dependency changes invalidate it while doc-only edits reuse the compiled `Website` executable.

**Important:** `Website/deploy/` is gitignored. A deploy triggered only by the Vercel Git integration (without the GitHub Actions build) will be empty and return **404**.

In Vercel → **Settings → Build and Deployment → Ignored Build Step**, choose **Don't build anything**. That stops Git pushes from publishing production; only GitHub Actions (`vercel deploy --prod`) should deploy this site.

Required GitHub secrets: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`.

To confirm production matches the latest docs change, check the **Ready** deployment in Vercel whose commit matches your merge and was created by the Website workflow deploy job—not a Git-only deployment named after a unrelated commit.

### Manual deploy

```bash
./scripts/saga build
cd Website/deploy
vercel deploy --prod
```

### 404 after Vercel import

The congratulations screen from Vercel imports the repo, but `deploy/` does not exist in git. Run the manual deploy above once, or push to `main` with GitHub secrets configured and let the Website workflow deploy.

## Project layout

```
Website/
├── Package.swift
├── Sources/Website/
│   ├── main.swift        # Saga pipeline
│   └── templates.swift   # HTML templates (Swim)
├── deploy/               # Generated output (gitignored)
└── vercel.json
```
