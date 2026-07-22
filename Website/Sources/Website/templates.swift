import Foundation
import HTML
import Moon
import Saga
import SagaSwimRenderer

func baseHtml(title pageTitle: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      meta(content: "Blueprint — iOS architecture reference built with SwiftUI", name: "description")
      title { pageTitle }
      link(href: "/static/style.css", rel: "stylesheet")
    }
    body {
      header(class: "site-header") {
        nav {
          a(class: "site-title", href: "/") { "Blueprint" }
          div(class: "nav-links") {
            a(href: "/chapters/") { "Chapters" }
            a(href: "https://github.com/luizmellodev/Blueprint") { "GitHub" }
          }
        }
      }
      children()
      footer(class: "site-footer") {
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

func statusBadge(_ status: String?) -> Node {
  switch status {
  case "done":
    span(class: "badge badge-done") { "Done" }
  case "in-progress":
    span(class: "badge badge-in-progress") { "In progress" }
  case "coming-soon":
    span(class: "badge badge-coming-soon") { "Coming soon" }
  default:
    span(class: "badge badge-done") { "Done" }
  }
}

func chapterLabel(_ number: Int) -> String {
  "Chapter \(number)"
}

func renderChapter(context: ItemRenderingContext<ChapterMetadata>) -> Node {
  baseHtml(title: "\(context.item.title) — Blueprint") {
    div(class: "page") {
      div(class: "chapter-meta") {
        span(class: "chapter-number") { chapterLabel(context.item.metadata.chapter) }
        statusBadge(context.item.metadata.status)
      }
      article {
        h1 { context.item.title }
        Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
      }
      div(class: "chapter-nav") {
        a(href: "/chapters/") { "← All chapters" }
      }
    }
  }
}

func renderChapterIndex(context: ItemsRenderingContext<ChapterMetadata>) -> Node {
  baseHtml(title: "Chapters — Blueprint") {
    div(class: "page") {
      h1 { "Chapters" }
      p {
        "Step-by-step documentation for building Discover, the example app in the Blueprint repository."
      }
      div {
        context.items.map { chapter in
          a(class: "chapter-card", href: chapter.url) {
            div(class: "chapter-card-header") {
              span(class: "chapter-number") { chapterLabel(chapter.metadata.chapter) }
              statusBadge(chapter.metadata.status)
            }
            h2 { chapter.title }
            if let summary = chapter.metadata.summary {
              p { summary }
            }
          }
        }
      }
    }
  }
}

func renderPage(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  baseHtml(title: "\(context.item.title) — Blueprint") {
    div(class: "page") {
      div(class: "hero") {
        h1 { context.item.title }
      }
      Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
    }
  }
}
