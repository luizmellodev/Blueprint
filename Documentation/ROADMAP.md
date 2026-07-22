# Blueprint Roadmap

Blueprint grows by **chapters:** each version adds code, documentation, and an architectural decision.

The app (**Discover**) demonstrates. The repository (**Blueprint**) teaches.

---

## Released

| Version | Chapter | Code | Docs | ADR |
|---|---|---|---|---|
| v0.1 | Project Setup | Xcode project, folder structure | [Getting Started](/guides/getting-started/) |, |
| v0.2 | Modularization | DesignSystem + Networking packages | [Modularization](/architecture/modularization/) | [0001](/decisions/0001-modularization/) |
| v0.3 | Design System | DSSpacing, DSTypography, DSRadius | [Design System](/architecture/design-system/) |, |
| v0.4 | Navigation | AppRoute, AppRouter, RouterProtocol | [Navigation](/architecture/navigation/) | [0002](/decisions/0002-navigation/) |
| v0.5 | Dependency Injection | DIContainer, bundles, factories | [Dependency Injection](/architecture/dependency-injection/) | [0003](/decisions/0003-dependency-injection/) |
| v0.6 | Networking | Geoapify API, DTOs, cache | [Networking](/architecture/networking/) | [0006](/decisions/0006-xcconfig-api-keys/) |
| v0.7 | Persistence | SwiftData, FavoritePOI | [SwiftData](/architecture/swiftdata/) | [0005](/decisions/0005-swiftdata-domain-separation/) |
| v0.8 | Testing | Swift Testing, mocks | [Testing](/architecture/testing/) |, |
| v0.9 | Accessibility | VoiceOver, Dynamic Type, skeletons | [Accessibility](/architecture/accessibility/) |, |
| v0.10 | CI/CD | GitHub Actions | [CI/CD Guide](/guides/ci-cd/) |, |
| v0.11 | Performance | Cache TTL, pagination, OSLog | [Performance](/architecture/performance/) |, |
| v0.12 | Documentation Site | Saga static site | [Documentation Site](/guides/documentation-site/) | [0007](/decisions/0007-saga-documentation-site/) |

---

## Planned

| Version | Chapter | Focus |
|---|---|---|
| v0.13 | Deep Links | `blueprint://place/:id`, Universal Links |
| v0.14 | Map View | MapKit integration behind feature flag |
| v0.15 | Remote Config | Firebase Remote Config for feature flags |
| v0.16 | DocC | API reference for public Package APIs |
| v0.17 | pt-BR | Portuguese documentation |

More ideas and alternatives (Coordinators, Fastlane, Swinject, coverage gates, widgets): [Future Directions](/guides/future-directions/).

---

## Principles

Every chapter must answer:

1. **What problem does this solve?**
2. **Why this solution?**
3. **What are the alternatives and trade-offs?**
4. **How is it implemented in Blueprint?**

Nothing enters the project without a didactic reason.
