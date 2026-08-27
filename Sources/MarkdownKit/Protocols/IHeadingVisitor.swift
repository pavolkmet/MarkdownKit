import Foundation

/// Supplies optional attributes for Markdown headings.
public protocol IHeadingVisitor {
    /// Returns heading attributes, or `nil` to keep the heading as ordinary text.
    mutating func attributes(for text: String, level: Int) -> AttributeContainer?
}
