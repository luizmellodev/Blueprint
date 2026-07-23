import Foundation

enum DocSection: String, CaseIterable, Sendable {
  case architecture
  case website

  var label: String {
    switch self {
    case .architecture: "Architecture"
    case .website: "Website"
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
  SiteEntry(section: .architecture, slug: "overview", title: "Overview", order: 0),
  SiteEntry(section: .architecture, slug: "mvvm", title: "MVVM", order: 1),
  SiteEntry(section: .architecture, slug: "domain", title: "Domain", order: 2),
  SiteEntry(section: .architecture, slug: "repositories-and-services", title: "Repositories & Services", order: 3),
  SiteEntry(section: .architecture, slug: "networking", title: "Networking", order: 4),
  SiteEntry(section: .architecture, slug: "swiftdata", title: "SwiftData", order: 5),
  SiteEntry(section: .architecture, slug: "dependency-injection", title: "Dependency Injection", order: 6),
  SiteEntry(section: .architecture, slug: "navigation", title: "Navigation", order: 7),
  SiteEntry(section: .architecture, slug: "modularization", title: "Modularization", order: 8),
  SiteEntry(section: .website, slug: "overview", title: "Site Overview", order: 0),
  SiteEntry(section: .website, slug: "implementation", title: "Implementation", order: 1),
  SiteEntry(section: .website, slug: "deploy", title: "Build & Preview", order: 2),
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
