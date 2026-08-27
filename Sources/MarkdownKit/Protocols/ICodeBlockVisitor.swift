import Foundation

/// Renders a fenced or indented code block.
public protocol ICodeBlockVisitor {
    /// Returns the rendered code block.
    mutating func visit(code: String, visitor: inout any ITextVisitor) -> AttributedString
}
