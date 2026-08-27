import Foundation

/// Supplies attributes for emphasized Markdown ranges.
public protocol IEmphasisVisitor {
    /// Returns emphasis attributes, or `nil` to render the range as ordinary text.
    mutating func attributes(for text: String) -> AttributeContainer?
}
