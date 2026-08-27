import Foundation

/// Renders an inline code span.
public protocol IInlineCodeVisitor {
    /// Returns the rendered code span.
    mutating func visit(code: String, visitor: inout any ITextVisitor) -> AttributedString
}
