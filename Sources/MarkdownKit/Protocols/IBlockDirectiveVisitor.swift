import Foundation

/// Renders a Markdown block directive from its rendered children.
public protocol IBlockDirectiveVisitor {
    /// Returns the rendered block directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
