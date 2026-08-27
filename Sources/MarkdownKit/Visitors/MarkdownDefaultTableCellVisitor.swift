import Foundation

/// The default table-cell visitor, which preserves its rendered children.
public struct MarkdownDefaultTableCellVisitor: ITableCellVisitor {

    // MARK: - Initialization - Public

    /// Creates the default table-cell visitor.
    public init() {}

    // MARK: - ITableCellVisitor

    /// Concatenates the cell's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
