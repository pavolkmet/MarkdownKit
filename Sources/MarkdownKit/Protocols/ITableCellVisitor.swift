import Foundation

/// Renders a Markdown table cell.
public protocol ITableCellVisitor {
    /// Returns the rendered table cell.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
