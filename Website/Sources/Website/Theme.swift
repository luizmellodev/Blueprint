import Foundation

enum Theme {
  static let body = "min-h-screen bg-zinc-50 text-zinc-900 antialiased dark:bg-zinc-950 dark:text-zinc-50"

  static let topbar = "sticky top-0 z-50 border-b border-zinc-200/80 bg-white/80 backdrop-blur-md dark:border-zinc-800 dark:bg-zinc-950/80"
  static let topbarInner = "mx-auto flex h-14 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8"
  static let brand = "flex items-center gap-2.5 font-semibold text-zinc-900 dark:text-zinc-50"
  static let brandMark = "flex h-7 w-7 items-center justify-center rounded-lg bg-blue-600 text-sm font-bold text-white"
  static let topbarNav = "flex items-center gap-1 sm:gap-2"
  static let topbarLink = "rounded-lg px-3 py-1.5 text-sm font-medium text-zinc-500 transition hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-50"
  static let topbarLinkActive = "rounded-lg bg-blue-50 px-3 py-1.5 text-sm font-semibold text-blue-600 dark:bg-blue-950 dark:text-blue-400"
  static let githubLink = "ml-2 border-l border-zinc-200 pl-4 dark:border-zinc-800"

  static let docsShell = "mx-auto grid max-w-7xl lg:grid-cols-[16rem_minmax(0,1fr)] lg:gap-10"
  static let sidebar = "hidden border-r border-zinc-200 pr-6 lg:sticky lg:top-14 lg:block lg:h-[calc(100vh-3.5rem)] lg:overflow-y-auto lg:py-8 dark:border-zinc-800"
  static let sidebarGroup = "mb-6"
  static let sidebarSection = "mb-2 block px-2 text-xs font-bold uppercase tracking-wider text-zinc-400"
  static let sidebarSectionActive = "mb-2 block px-2 text-xs font-bold uppercase tracking-wider text-blue-600 dark:text-blue-400"
  static let sidebarLink = "block rounded-md px-2 py-1.5 text-sm text-zinc-600 transition hover:bg-zinc-100 hover:text-zinc-900 dark:text-zinc-400 dark:hover:bg-zinc-900 dark:hover:text-zinc-50"
  static let sidebarLinkActive = "block rounded-md bg-blue-50 px-2 py-1.5 text-sm font-medium text-blue-700 dark:bg-blue-950 dark:text-blue-300"
  static let docsMain = "min-w-0 px-4 py-8 sm:px-6 lg:px-0 lg:py-10 lg:pr-8"

  static let prose = """
    prose prose-zinc max-w-3xl dark:prose-invert \
    prose-headings:scroll-mt-20 prose-headings:font-sem prose-headings:tracking-tight \
    prose-a:font-medium prose-a:text-blue-600 prose-a:no-underline hover:prose-a:underline \
    dark:prose-a:text-blue-400 \
    prose-code:rounded prose-code:bg-zinc-100 prose-code:px-1 prose-code:py-0.5 prose-code:before:content-none prose-code:after:content-none \
    dark:prose-code:bg-zinc-900 \
    prose-pre:rounded-xl prose-pre:border prose-pre:border-zinc-200 prose-pre:bg-zinc-50 dark:prose-pre:border-zinc-800 dark:prose-pre:bg-zinc-900
    """

  static let eyebrow = "text-sm font-semibold uppercase tracking-wide text-blue-600 dark:text-blue-400"
  static let pageTitle = "mt-2 text-3xl font-bold tracking-tight text-zinc-900 sm:text-4xl dark:text-zinc-50"
  static let lead = "mt-3 text-lg text-zinc-600 dark:text-zinc-400"

  static let tileGrid = "not-prose mt-8 grid gap-3 sm:grid-cols-2"
  static let tile = """
    group flex flex-col rounded-xl border border-zinc-200 bg-white p-5 transition \
    hover:border-blue-300 hover:shadow-sm dark:border-zinc-800 dark:bg-zinc-900 dark:hover:border-blue-700
    """
  static let tileTitle = "font-semibold text-zinc-900 group-hover:text-blue-600 dark:text-zinc-50 dark:group-hover:text-blue-400"
  static let tileSummary = "mt-1 text-sm text-zinc-500 dark:text-zinc-400"

  static let footerNav = "not-prose mt-16 grid gap-3 border-t border-zinc-200 pt-8 sm:grid-cols-2 dark:border-zinc-800"
  static let navCard = "flex flex-col rounded-xl border border-zinc-200 p-4 transition hover:border-blue-300 dark:border-zinc-800 dark:hover:border-blue-700"
  static let navLabel = "text-xs font-bold uppercase tracking-wide text-zinc-400"
  static let navTitle = "mt-1 font-medium text-zinc-900 dark:text-zinc-50"

  static let badgeAccepted = "inline-flex rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300"
  static let badgeProposed = "inline-flex rounded-full bg-amber-50 px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide text-amber-700 dark:bg-amber-950 dark:text-amber-300"
  static let badgeDeprecated = "inline-flex rounded-full bg-zinc-100 px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400"
  static let badgeDate = "inline-flex rounded-full bg-zinc-100 px-2.5 py-0.5 text-xs font-medium text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400"

  static let siteFooter = "border-t border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-950"
  static let siteFooterInner = "mx-auto max-w-7xl px-4 py-6 text-sm text-zinc-500 sm:px-6 lg:px-8"
}
