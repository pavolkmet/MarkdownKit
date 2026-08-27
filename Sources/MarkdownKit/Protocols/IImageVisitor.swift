import Foundation

/// Renders a Markdown image from its alternative text.
public protocol IImageVisitor {
    /// Returns the rendered image representation.
    mutating func visit(altText: String, visitor: inout any ITextVisitor) -> AttributedString
}
