import Foundation

/// Renders a raw HTML block.
public protocol IHTMLBlockVisitor {
    /// Returns the rendered raw HTML block.
    mutating func visit(rawHTML: String, visitor: inout any ITextVisitor) -> AttributedString
}
