import Foundation

/// Renders a paragraph from its inline children.
public protocol IParagraphVisitor {
    /// Returns the rendered paragraph.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
