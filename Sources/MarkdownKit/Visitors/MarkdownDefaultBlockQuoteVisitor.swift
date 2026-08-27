import Foundation

/// The default block-quote visitor, which separates block children with line breaks.
public struct MarkdownDefaultBlockQuoteVisitor: IBlockQuoteVisitor {

    // MARK: - Initialization - Public

    /// Creates the default block-quote visitor.
    public init() {}

    // MARK: - IBlockQuoteVisitor

    /// Joins rendered block children with line breaks from the text visitor.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
