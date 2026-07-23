# Blueprint Roadmap

Blueprint grows by **chapters:** each version adds code and updates the [site overview](https://ios-blueprint.vercel.app/).

The app (**Discover**) demonstrates. The repository (**Blueprint**) teaches.

---

## Released

| Version | Chapter | Focus |
|---|---|---|
| v0.1 | Project Setup | Xcode project, folder structure |
| v0.2 | Modularization | DesignSystem + Networking packages |
| v0.3 | Design System | DSSpacing, DSTypography, DSRadius |
| v0.4 | Navigation | AppRoute, AppRouter, RouterProtocol |
| v0.5 | Dependency Injection | DIContainer, bundles, factories |
| v0.6 | Networking | Geoapify API, DTOs, cache |
| v0.7 | Persistence | SwiftData, FavoritePOI |
| v0.8 | Testing | Swift Testing, mocks |
| v0.9 | Accessibility | VoiceOver, Dynamic Type, skeletons |
| v0.10 | CI/CD | GitHub Actions |
| v0.11 | Performance | Cache TTL, pagination, OSLog |
| v0.12 | Documentation Site | Saga static site |

---

## Planned

| Version | Chapter | Focus |
|---|---|---|
| v0.13 | Deep Links | `blueprint://place/:id`, Universal Links |
| v0.14 | Map View | MapKit integration behind feature flag |
| v0.15 | Remote Config | Firebase Remote Config for feature flags |
| v0.16 | DocC | API reference for public Package APIs |
| v0.17 | pt-BR | Portuguese documentation |

---

## Principles

Every chapter must answer:

1. **What problem does this solve?**
2. **Why this solution?**
3. **What are the alternatives and trade-offs?**
4. **How is it implemented in Blueprint?**

Nothing enters the project without a didactic reason.
