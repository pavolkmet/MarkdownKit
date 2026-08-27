import Foundation

/// Renders the body section of a Markdown table.
public protocol ITableBodyVisitor {
    /// Returns the rendered table body.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
