import Foundation

enum DocSection: String, CaseIterable, Sendable {
  case guides
  case architecture
  case concepts
  case decisions

  var label: String {
    switch self {
    case .guides: "Guides"
    case .architecture: "Architecture"
    case .concepts: "Concepts"
    case .decisions: "ADRs"
    }
  }

  var indexPath: String { "/\(rawValue)/" }
}

struct SiteEntry: Sendable {
  let section: DocSection
  let slug: String
  let title: String
  let order: Int

  var path: String { "/\(section.rawValue)/\(slug)/" }
}

let siteCatalog: [SiteEntry] = [
  // Guides
  SiteEntry(section: .guides, slug: "getting-started", title: "Getting Started", order: 1),
  SiteEntry(section: .guides, slug: "api-key-setup", title: "API Key Setup", order: 2),
  SiteEntry(section: .guides, slug: "running-tests", title: "Running Tests", order: 3),
  SiteEntry(section: .guides, slug: "ci-cd", title: "CI/CD", order: 4),
  SiteEntry(section: .guides, slug: "documentation-site", title: "Documentation Site", order: 5),
  SiteEntry(section: .guides, slug: "roadmap", title: "Roadmap", order: 6),
  // Architecture
  SiteEntry(section: .architecture, slug: "modularization", title: "Modularization", order: 1),
  SiteEntry(section: .architecture, slug: "design-system", title: "Design System", order: 2),
  SiteEntry(section: .architecture, slug: "navigation", title: "Navigation", order: 3),
  SiteEntry(section: .architecture, slug: "dependency-injection", title: "Dependency Injection", order: 4),
  SiteEntry(section: .architecture, slug: "networking", title: "Networking", order: 5),
  SiteEntry(section: .architecture, slug: "persistence", title: "Persistence", order: 6),
  SiteEntry(section: .architecture, slug: "testing", title: "Testing", order: 7),
  SiteEntry(section: .architecture, slug: "accessibility", title: "Accessibility", order: 8),
  SiteEntry(section: .architecture, slug: "performance", title: "Performance", order: 9),
  // Concepts
  SiteEntry(section: .concepts, slug: "observation", title: "Observation", order: 1),
  SiteEntry(section: .concepts, slug: "repository-pattern", title: "Repository Pattern", order: 2),
  SiteEntry(section: .concepts, slug: "use-cases", title: "Use Cases", order: 3),
  SiteEntry(section: .concepts, slug: "feature-flags", title: "Feature Flags", order: 4),
  SiteEntry(section: .concepts, slug: "caching", title: "Caching", order: 5),
  SiteEntry(section: .concepts, slug: "logging", title: "Logging", order: 6),
  // ADRs
  SiteEntry(section: .decisions, slug: "0001-modularization", title: "0001: Modularization", order: 1),
  SiteEntry(section: .decisions, slug: "0002-navigation", title: "0002: Navigation", order: 2),
  SiteEntry(section: .decisions, slug: "0003-dependency-injection", title: "0003: Dependency Injection", order: 3),
  SiteEntry(section: .decisions, slug: "0004-observable-state", title: "0004: Observable State", order: 4),
  SiteEntry(section: .decisions, slug: "0005-swiftdata-domain-separation", title: "0005: SwiftData Separation", order: 5),
  SiteEntry(section: .decisions, slug: "0006-xcconfig-api-keys", title: "0006: xcconfig API Keys", order: 6),
  SiteEntry(section: .decisions, slug: "0007-saga-documentation-site", title: "0007: Saga Documentation", order: 7),
]

func entries(for section: DocSection) -> [SiteEntry] {
  siteCatalog.filter { $0.section == section }.sorted { $0.order < $1.order }
}

func adjacentEntries(for entry: SiteEntry) -> (previous: SiteEntry?, next: SiteEntry?) {
  let sectionEntries = entries(for: entry.section)
  guard let index = sectionEntries.firstIndex(where: { $0.slug == entry.slug }) else {
    return (nil, nil)
  }
  let previous = index > 0 ? sectionEntries[index - 1] : nil
  let next = index < sectionEntries.count - 1 ? sectionEntries[index + 1] : nil
  return (previous, next)
}

func entry(for section: DocSection, slug: String) -> SiteEntry? {
  siteCatalog.first { $0.section == section && $0.slug == slug }
}
