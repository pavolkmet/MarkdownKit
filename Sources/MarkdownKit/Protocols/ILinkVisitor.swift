import Foundation

/// Supplies attributes for Markdown links and detected unmarked links.
public protocol ILinkVisitor {
    /// Whether ordinary text should be scanned for unmarked links.
    var shouldDetectUnmarkedLinks: Bool { get }

    /// Returns attributes for a rendered link, or `nil` to leave it as ordinary text.
    mutating func attributes(for text: String, destination: URL, source: MarkdownLinkSource) -> AttributeContainer?
}
