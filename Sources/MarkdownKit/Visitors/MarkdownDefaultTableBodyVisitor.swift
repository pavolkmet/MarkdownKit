import Foundation

/// The default table-body visitor, which separates rows with line breaks.
public struct MarkdownDefaultTableBodyVisitor: ITableBodyVisitor {

    // MARK: - Initialization - Public

    /// Creates the default table-body visitor.
    public init() {}

    // MARK: - ITableBodyVisitor

    /// Joins rendered rows with line breaks from the text visitor.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
