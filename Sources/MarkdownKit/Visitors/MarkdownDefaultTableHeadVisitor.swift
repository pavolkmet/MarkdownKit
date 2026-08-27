import Foundation

/// The default table-header visitor, which separates rows with pipe characters.
public struct MarkdownDefaultTableHeadVisitor: ITableHeadVisitor {

    // MARK: - Initialization - Public

    /// Creates the default table-header visitor.
    public init() {}

    // MARK: - ITableHeadVisitor

    /// Joins rendered children with attributed pipe separators.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: " | ")
        )
    }
}
