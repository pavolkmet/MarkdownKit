import Foundation

/// Renders a complete Markdown table.
public protocol ITableVisitor {
    /// Returns the rendered table.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
