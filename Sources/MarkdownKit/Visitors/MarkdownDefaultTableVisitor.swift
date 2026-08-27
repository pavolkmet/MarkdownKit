import Foundation

/// The default table visitor, which separates table sections with line breaks.
public struct MarkdownDefaultTableVisitor: ITableVisitor {

    // MARK: - Initialization - Public

    /// Creates the default table visitor.
    public init() {}

    // MARK: - ITableVisitor

    /// Joins rendered table sections with line breaks from the text visitor.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
