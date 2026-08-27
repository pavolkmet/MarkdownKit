import Foundation

/// Renders raw inline HTML.
public protocol IInlineHTMLVisitor {
    /// Returns the rendered raw HTML.
    mutating func visit(rawHTML: String, visitor: inout any ITextVisitor) -> AttributedString
}
