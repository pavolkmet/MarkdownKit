import Foundation

/// Supplies optional attributes for strikethrough Markdown ranges.
public protocol IStrikethroughVisitor {
    /// Returns strikethrough attributes, or `nil` to keep the range as ordinary text.
    mutating func attributes(for text: String) -> AttributeContainer?
}
