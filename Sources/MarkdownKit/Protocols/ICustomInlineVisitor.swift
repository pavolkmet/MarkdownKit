import Foundation

/// Renders a custom inline node.
public protocol ICustomInlineVisitor {
    /// Returns the rendered custom inline text.
    mutating func visit(text: String, visitor: inout any ITextVisitor) -> AttributedString
}
