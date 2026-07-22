import Foundation

enum MermaidProcessor {
  private static let blockPattern = #"<pre><code class="language-mermaid">([\s\S]*?)</code></pre>"#

  static func prepareBlocks(in html: String) -> String {
    guard let regex = try? NSRegularExpression(pattern: blockPattern) else { return html }
    let nsHTML = html as NSString
    let matches = regex.matches(in: html, range: NSRange(location: 0, length: nsHTML.length))
    guard !matches.isEmpty else { return html }

    var result = html
    for match in matches.reversed() {
      let fullRange = match.range(at: 0)
      let innerRange = match.range(at: 1)
      let innerHTML = nsHTML.substring(with: innerRange)
      let source = decodeEntities(stripTags(from: innerHTML))
      let replacement = """
        <div class="not-prose my-8 overflow-x-auto rounded-xl border border-zinc-200 bg-white p-4 dark:border-zinc-800 dark:bg-zinc-900"><div class="mermaid mermaid-wide">\(source)</div></div>
        """
      result = (result as NSString).replacingCharacters(in: fullRange, with: replacement)
    }
    return result
  }

  private static func stripTags(from html: String) -> String {
    html.replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
  }

  private static func decodeEntities(_ text: String) -> String {
    text
      .replacingOccurrences(of: "&lt;", with: "<")
      .replacingOccurrences(of: "&gt;", with: ">")
      .replacingOccurrences(of: "&amp;", with: "&")
      .replacingOccurrences(of: "&quot;", with: "\"")
      .replacingOccurrences(of: "&#39;", with: "'")
  }
}
