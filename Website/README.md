# Blueprint Docs Site

Static documentation site for the Blueprint iOS architecture reference, built with [Saga](https://getsaga.dev/).

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
2. Install Vercel CLI: `npm i -g vercel`
3. Link the project: `cd Website && vercel link`
4. Add `VERCEL_TOKEN` to GitHub repository secrets ([create token](https://vercel.com/account/tokens))
5. Add `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` from `.vercel/project.json` after linking

### Vercel project settings (required for GitHub Actions)

The deploy job uploads pre-built files from CI. **Root Directory must be empty.**

Go to [Project Settings → General](https://vercel.com/luizmellodev/blueprint/settings):

| Setting | Value |
|---|---|
| **Root Directory** | **empty** (delete `Website` if present, then Save) |
| **Build Command** | off / empty |
| **Output Directory** | off / empty |
| **Install Command** | off / empty |
| **Ignored Build Step** | `exit 1` |

If Root Directory is `Website`, the CLI looks for paths like `site/Website` and deploy fails.

### Automatic deploy

Push to `main` triggers GitHub Actions: `saga build` on macOS, then `vercel deploy deploy --prod`.

**Important:** `Website/deploy/` is gitignored. A deploy triggered only by the Vercel Git integration (without the GitHub Actions build) will be empty and return **404**.

In Vercel → Settings → Git, either disable production deployments from Git, or set **Ignored Build Step** to `exit 1` so only GitHub Actions publishes the site.

Required GitHub secrets: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`.

### Manual deploy

```bash
./scripts/saga build
cd Website
vercel deploy deploy --prod
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
