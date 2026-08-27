import Foundation

/// Supplies attributes for strongly emphasized Markdown ranges.
public protocol IStrongVisitor {
    /// Returns strong attributes, or `nil` to render the range as ordinary text.
    mutating func attributes(for text: String) -> AttributeContainer?
}
