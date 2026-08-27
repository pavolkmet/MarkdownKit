import Foundation

/// The default table-row visitor, which separates cells with pipe characters.
public struct MarkdownDefaultTableRowVisitor: ITableRowVisitor {

    // MARK: - Initialization - Public

    /// Creates the default table-row visitor.
    public init() {}

    // MARK: - ITableRowVisitor

    /// Joins rendered cells with attributed pipe separators.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: " | ")
        )
    }
}
