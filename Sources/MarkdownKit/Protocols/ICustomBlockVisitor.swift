import Foundation

/// Renders a custom block node from its rendered children.
public protocol ICustomBlockVisitor {
    /// Returns the rendered custom block.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
