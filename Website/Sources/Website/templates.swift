import Foundation
import HTML
import Moon
import Saga
import SagaSwimRenderer

// MARK: - Shell

func docsShell(
  title pageTitle: String,
  activeSection: DocSection? = nil,
  activeSlug: String? = nil,
  isOverview: Bool = false,
  @NodeBuilder content: () -> NodeConvertible
) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      meta(content: "Blueprint: a public iOS architecture study project built with SwiftUI", name: "description")
      title { pageTitle }
      link(href: Saga.hashed("/static/output.css"), rel: "stylesheet")
    }
    body(class: Theme.body) {
      header(class: Theme.topbar) {
        div(class: Theme.topbarInner) {
          a(class: Theme.brand, href: "/") {
            span(class: Theme.brandMark) { "B" }
            span { "Blueprint" }
          }
          nav(class: Theme.topbarNav) {
            DocSection.allCases.map { section in
              a(
                class: section == activeSection ? Theme.topbarLinkActive : Theme.topbarLink,
                href: section.indexPath
              ) { section.label }
            }
            a(
              class: "\(Theme.topbarLink) \(Theme.githubLink)",
              href: "https://github.com/luizmellodev/Blueprint",
              rel: "noopener"
            ) {
              "GitHub"
            }
          }
        }
      }
      div(class: Theme.docsShell) {
        aside(class: Theme.sidebar) {
          div(class: Theme.sidebarGroup) {
            a(
              class: isOverview ? Theme.sidebarLinkActive : Theme.sidebarLink,
              href: "/"
            ) { "Overview" }
          }
          DocSection.allCases.map { section in
            div(class: Theme.sidebarGroup) {
              a(
                class: section == activeSection ? Theme.sidebarSectionActive : Theme.sidebarSection,
                href: section.indexPath
              ) { section.label }
              nav {
                entries(for: section).map { entry in
                  a(
                    class: entry.slug == activeSlug && section == activeSection
                      ? Theme.sidebarLinkActive : Theme.sidebarLink,
                    href: entry.path
                  ) {
                    entry.title
                  }
                }
              }
            }
          }
        }
        main(class: Theme.docsMain) {
          content()
        }
      }
      footer(class: Theme.siteFooter) {
        div(class: Theme.siteFooterInner) {
          p {
            "Blueprint by "
            a(class: "text-blue-600 hover:underline dark:text-blue-400", href: "https://github.com/luizmellodevo", rel: "noopener") {
              "Luiz Mello"
            }
            " · Built with "
            a(class: "text-blue-600 hover:underline dark:text-blue-400", href: "https://getsaga.dev/") { "Saga" }
            " · "
            a(class: "text-blue-600 hover:underline dark:text-blue-400", href: "https://github.com/luizmellodev/Blueprint") {
              "Source"
            }
          }
        }
      }
      mermaidScripts()
    }
  }
}

@NodeBuilder
func mermaidScripts() -> Node {
  script(src: "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js") {}
  script { Node.raw(#"mermaid.initialize({ startOnLoad: true, theme: "neutral", flowchart: { useMaxWidth: true, htmlLabels: true, curve: "basis", padding: 12, nodeSpacing: 24, rankSpacing: 32 } });"#) }
}

// MARK: - Shared components

func adrStatusBadge(_ status: String) -> Node {
  switch status.lowercased() {
  case "accepted":
    span(class: Theme.badgeAccepted) { "Accepted" }
  case "proposed":
    span(class: Theme.badgeProposed) { "Proposed" }
  case "deprecated":
    span(class: Theme.badgeDeprecated) { "Deprecated" }
  default:
    span(class: Theme.badgeAccepted) { status }
  }
}

func docHeader(eyebrow: String, title: String, summary: String?, badges: [Node] = []) -> Node {
  div(class: "not-prose mb-8") {
    p(class: Theme.eyebrow) { eyebrow }
    h1(class: Theme.pageTitle) { title }
    if let summary {
      p(class: Theme.lead) { summary }
    }
    if !badges.isEmpty {
      div(class: "mt-4 flex flex-wrap gap-2") {
        badges
      }
    }
  }
}

func proseBody(_ html: String) -> Node {
  let highlighted = Moon.shared.highlightCodeBlocks(in: html)
  let prepared = MermaidProcessor.prepareBlocks(in: highlighted)
  return Node.raw(prepared)
}

func footerNav(section: DocSection, slug: String) -> Node {
  guard let current = entry(for: section, slug: slug) else { return div() }
  let adjacent = adjacentEntries(for: current)
  return div(class: Theme.footerNav) {
    if let previous = adjacent.previous {
      a(class: Theme.navCard, href: previous.path) {
        span(class: Theme.navLabel) { "Previous" }
        span(class: Theme.navTitle) { previous.title }
      }
    } else {
      div()
    }
    if let next = adjacent.next {
      a(class: "\(Theme.navCard) sm:text-right", href: next.path) {
        span(class: Theme.navLabel) { "Next" }
        span(class: Theme.navTitle) { next.title }
      }
    }
  }
}

func sectionIndexTiles(section: DocSection, items: [Item<DocMetadata>]) -> Node {
  div(class: Theme.tileGrid) {
    items.map { item in
      a(class: Theme.tile, href: item.url) {
        h2(class: Theme.tileTitle) { item.title }
        if let summary = item.metadata.summary {
          p(class: Theme.tileSummary) { summary }
        }
      }
    }
  }
}

func adrIndexTiles(items: [Item<ADRMetadata>]) -> Node {
  div(class: Theme.tileGrid) {
    items.map { item in
      a(class: Theme.tile, href: item.url) {
        h2(class: Theme.tileTitle) { item.title }
        if let summary = item.metadata.summary {
          p(class: Theme.tileSummary) { summary }
        }
        div(class: "mt-3") {
          adrStatusBadge(item.metadata.status)
        }
      }
    }
  }
}

// MARK: - Website

func renderWebsite(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) | Blueprint", activeSection: .website, activeSlug: slug) {
    article(class: Theme.prose) {
      docHeader(eyebrow: "Website", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .website, slug: slug)
    }
  }
}

func renderWebsiteIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Website | Blueprint", activeSection: .website) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Website",
        title: "Documentation Site",
        summary: "How Blueprint builds this site with Saga, Swift, and Tailwind."
      )
      sectionIndexTiles(section: .website, items: context.items)
    }
  }
}

// MARK: - Home

func renderHome(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  docsShell(title: "Blueprint | Documentation", isOverview: true) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Overview",
        title: "Blueprint",
        summary: "A public iOS architecture study project. Best practices in the open, not a universal reference."
      )
      proseBody(context.item.body)
    }
  }
}

func slugFromURL(_ url: String) -> String {
  url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    .components(separatedBy: "/")
    .last ?? url
}

func renderGuide(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) | Blueprint", activeSection: .guides, activeSlug: slug) {
    article(class: Theme.prose) {
      docHeader(eyebrow: "Guide", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .guides, slug: slug)
    }
  }
}

func renderGuideIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Guides | Blueprint", activeSection: .guides) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Guides",
        title: "Guides",
        summary: "Practical setup: clone, configure, build, test, and deploy."
      )
      sectionIndexTiles(section: .guides, items: context.items)
    }
  }
}

// MARK: - Architecture

func renderArchitecture(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) | Blueprint", activeSection: .architecture, activeSlug: slug) {
    article(class: Theme.prose) {
      docHeader(eyebrow: "Architecture", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .architecture, slug: slug)
    }
  }
}

func renderArchitectureIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Architecture | Blueprint", activeSection: .architecture) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Architecture",
        title: "Architecture",
        summary: "Engineering decisions by layer: why we chose each pattern and how Discover implements it."
      )
      sectionIndexTiles(section: .architecture, items: context.items)
    }
  }
}

// MARK: - Concepts

func renderConcept(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) | Blueprint", activeSection: .concepts, activeSlug: slug) {
    article(class: Theme.prose) {
      docHeader(eyebrow: "Concept", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .concepts, slug: slug)
    }
  }
}

func renderConceptIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Concepts | Blueprint", activeSection: .concepts) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Concepts",
        title: "Concepts",
        summary: "Cross-cutting patterns that span layers: Use Cases and Logging."
      )
      sectionIndexTiles(section: .concepts, items: context.items)
    }
  }
}

// MARK: - ADRs

func renderADR(context: ItemRenderingContext<ADRMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  var badges: [Node] = [adrStatusBadge(context.item.metadata.status)]
  if let date = context.item.metadata.date {
    badges.append(span(class: Theme.badgeDate) { date })
  }
  return docsShell(title: "\(context.item.title) | Blueprint", activeSection: .decisions, activeSlug: slug) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "Architecture Decision Record",
        title: context.item.title,
        summary: context.item.metadata.summary,
        badges: badges
      )
      proseBody(context.item.body)
      footerNav(section: .decisions, slug: slug)
    }
  }
}

func renderADRIndex(context: ItemsRenderingContext<ADRMetadata>) -> Node {
  docsShell(title: "ADRs | Blueprint", activeSection: .decisions) {
    article(class: Theme.prose) {
      docHeader(
        eyebrow: "ADRs",
        title: "Architecture Decision Records",
        summary: "Formal records of why each major decision was made: context, alternatives, consequences."
      )
      adrIndexTiles(items: context.items)
    }
  }
}
