import Foundation

/// Renders the root document from its prepared block results.
public protocol IDocumentVisitor {
    /// Returns the rendered document from its block children.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
