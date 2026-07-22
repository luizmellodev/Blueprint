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
  @NodeBuilder content: () -> NodeConvertible
) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      meta(content: "Blueprint — A living handbook for modern SwiftUI architecture", name: "description")
      title { pageTitle }
      link(href: "/static/style.css", rel: "stylesheet")
    }
    body {
      header(class: "topbar") {
        div(class: "topbar-inner") {
          a(class: "brand", href: "/") {
            span(class: "brand-mark") { "B" }
            span(class: "brand-name") { "Blueprint" }
          }
          nav(class: "topbar-nav") {
            DocSection.allCases.map { section in
              a(
                class: section == activeSection ? "topbar-link active" : "topbar-link",
                href: section.indexPath
              ) { section.label }
            }
            a(class: "topbar-link github-link", href: "https://github.com/luizmellodev/Blueprint", rel: "noopener") {
              "GitHub"
            }
          }
        }
      }
      div(class: "docs-shell") {
        aside(class: "sidebar") {
          DocSection.allCases.map { section in
            div(class: "sidebar-group") {
              a(
                class: section == activeSection ? "sidebar-section active" : "sidebar-section",
                href: section.indexPath
              ) { section.label }
              nav(class: "sidebar-nav") {
                entries(for: section).map { entry in
                  a(
                    class: entry.slug == activeSlug && section == activeSection
                      ? "sidebar-link active" : "sidebar-link",
                    href: entry.path
                  ) {
                    span(class: "sidebar-title") { entry.title }
                  }
                }
              }
            }
          }
        }
        main(class: "docs-main") {
          content()
        }
      }
      footer(class: "site-footer") {
        div(class: "site-footer-inner") {
          p {
            "Built with "
            a(href: "https://getsaga.dev/") { "Saga" }
            " · "
            a(href: "https://github.com/luizmellodev/Blueprint") { "Source" }
          }
        }
      }
    }
  }
}

func homeShell(title pageTitle: String, @NodeBuilder content: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      meta(content: "Blueprint — A living handbook for modern SwiftUI architecture", name: "description")
      title { pageTitle }
      link(href: "/static/style.css", rel: "stylesheet")
    }
    body {
      header(class: "topbar") {
        div(class: "topbar-inner") {
          a(class: "brand", href: "/") {
            span(class: "brand-mark") { "B" }
            span(class: "brand-name") { "Blueprint" }
          }
          nav(class: "topbar-nav") {
            DocSection.allCases.map { section in
              a(class: "topbar-link", href: section.indexPath) { section.label }
            }
            a(class: "topbar-link github-link", href: "https://github.com/luizmellodev/Blueprint", rel: "noopener") {
              "GitHub"
            }
          }
        }
      }
      main(class: "landing") {
        content()
      }
      footer(class: "site-footer") {
        div(class: "site-footer-inner") {
          p {
            "Built with "
            a(href: "https://getsaga.dev/") { "Saga" }
            " · "
            a(href: "https://github.com/luizmellodev/Blueprint") { "Source" }
          }
        }
      }
    }
  }
}

// MARK: - Shared components

func adrStatusBadge(_ status: String) -> Node {
  switch status.lowercased() {
  case "accepted":
    span(class: "badge badge-done") { "Accepted" }
  case "proposed":
    span(class: "badge badge-in-progress") { "Proposed" }
  case "deprecated":
    span(class: "badge badge-soon") { "Deprecated" }
  default:
    span(class: "badge badge-done") { status }
  }
}

func docHeader(eyebrow: String, title: String, summary: String?, badges: [Node] = []) -> Node {
  div(class: "chapter-header") {
    p(class: "eyebrow") { eyebrow }
    h1 { title }
    if let summary {
      p(class: "lead") { summary }
    }
    if !badges.isEmpty {
      div(class: "badge-row") {
        badges
      }
    }
  }
}

func proseBody(_ html: String) -> Node {
  div(class: "prose-body") {
    Node.raw(Moon.shared.highlightCodeBlocks(in: html))
  }
}

func footerNav(section: DocSection, slug: String) -> Node {
  guard let current = entry(for: section, slug: slug) else { return div() }
  let adjacent = adjacentEntries(for: current)
  return div(class: "chapter-footer-nav") {
    if let previous = adjacent.previous {
      a(class: "nav-prev", href: previous.path) {
        span(class: "nav-label") { "Previous" }
        span(class: "nav-title") { previous.title }
      }
    } else {
      span(class: "nav-spacer")
    }
    if let next = adjacent.next {
      a(class: "nav-next", href: next.path) {
        span(class: "nav-label") { "Next" }
        span(class: "nav-title") { next.title }
      }
    }
  }
}

func sectionIndexTiles(section: DocSection, items: [Item<DocMetadata>]) -> Node {
  div(class: "chapter-grid") {
    items.map { item in
      a(class: "chapter-tile", href: item.url) {
        div(class: "tile-body") {
          h2 { item.title }
          if let summary = item.metadata.summary {
            p { summary }
          }
        }
      }
    }
  }
}

func adrIndexTiles(items: [Item<ADRMetadata>]) -> Node {
  div(class: "chapter-grid") {
    items.map { item in
      a(class: "chapter-tile", href: item.url) {
        div(class: "tile-body") {
          h2 { item.title }
          if let summary = item.metadata.summary {
            p { summary }
          }
        }
        adrStatusBadge(item.metadata.status)
      }
    }
  }
}

// MARK: - Guides

func slugFromURL(_ url: String) -> String {
  url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    .components(separatedBy: "/")
    .last ?? url
}

func renderGuide(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) — Blueprint", activeSection: .guides, activeSlug: slug) {
    article(class: "prose") {
      docHeader(eyebrow: "Guide", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .guides, slug: slug)
    }
  }
}

func renderGuideIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Guides — Blueprint", activeSection: .guides) {
    article(class: "prose") {
      docHeader(
        eyebrow: "Guides",
        title: "Guides",
        summary: "Practical setup — clone, configure, build, test, and deploy."
      )
      sectionIndexTiles(section: .guides, items: context.items)
    }
  }
}

// MARK: - Architecture

func renderArchitecture(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) — Blueprint", activeSection: .architecture, activeSlug: slug) {
    article(class: "prose") {
      docHeader(eyebrow: "Architecture", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .architecture, slug: slug)
    }
  }
}

func renderArchitectureIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Architecture — Blueprint", activeSection: .architecture) {
    article(class: "prose") {
      docHeader(
        eyebrow: "Architecture",
        title: "Architecture",
        summary: "Engineering decisions by layer — the problem, the solution, the trade-offs."
      )
      sectionIndexTiles(section: .architecture, items: context.items)
    }
  }
}

// MARK: - Concepts

func renderConcept(context: ItemRenderingContext<DocMetadata>) -> Node {
  let slug = slugFromURL(context.item.url)
  return docsShell(title: "\(context.item.title) — Blueprint", activeSection: .concepts, activeSlug: slug) {
    article(class: "prose") {
      docHeader(eyebrow: "Concept", title: context.item.title, summary: context.item.metadata.summary)
      proseBody(context.item.body)
      footerNav(section: .concepts, slug: slug)
    }
  }
}

func renderConceptIndex(context: ItemsRenderingContext<DocMetadata>) -> Node {
  docsShell(title: "Concepts — Blueprint", activeSection: .concepts) {
    article(class: "prose") {
      docHeader(
        eyebrow: "Concepts",
        title: "Concepts",
        summary: "Patterns used across the codebase — observation, repositories, use cases, and more."
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
    badges.append(span(class: "badge badge-date") { date })
  }
  return docsShell(title: "\(context.item.title) — Blueprint", activeSection: .decisions, activeSlug: slug) {
    article(class: "prose adr-page") {
      docHeader(eyebrow: "Architecture Decision Record", title: context.item.title, summary: context.item.metadata.summary, badges: badges)
      proseBody(context.item.body)
      footerNav(section: .decisions, slug: slug)
    }
  }
}

func renderADRIndex(context: ItemsRenderingContext<ADRMetadata>) -> Node {
  docsShell(title: "ADRs — Blueprint", activeSection: .decisions) {
    article(class: "prose") {
      docHeader(
        eyebrow: "ADRs",
        title: "Architecture Decision Records",
        summary: "Formal records of why each major decision was made — context, alternatives, consequences."
      )
      adrIndexTiles(items: context.items)
    }
  }
}

// MARK: - Home

func renderHome(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  homeShell(title: "Blueprint — A living handbook for modern SwiftUI architecture") {
    div(class: "landing-hero prose") {
      Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
    }
    section(class: "landing-sections") {
      div(class: "landing-sections-inner") {
        DocSection.allCases.map { section in
          div(class: "section-card") {
            h2 {
              a(href: section.indexPath) { section.label }
            }
            ul(class: "section-links") {
              entries(for: section).prefix(4).map { entry in
                li {
                  a(href: entry.path) { entry.title }
                }
              }
            }
            a(class: "section-more", href: section.indexPath) { "View all →" }
          }
        }
      }
    }
  }
}
