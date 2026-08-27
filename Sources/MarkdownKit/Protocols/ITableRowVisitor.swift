import Foundation

/// Renders a Markdown table row.
public protocol ITableRowVisitor {
    /// Returns the rendered table row.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
