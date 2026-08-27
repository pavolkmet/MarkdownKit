import Foundation

/// Renders the header section of a Markdown table.
public protocol ITableHeadVisitor {
    /// Returns the rendered table header.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
