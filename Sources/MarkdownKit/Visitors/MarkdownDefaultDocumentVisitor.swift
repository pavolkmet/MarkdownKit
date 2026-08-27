import Foundation

/// The default document visitor, which separates block children with line breaks.
public struct MarkdownDefaultDocumentVisitor: IDocumentVisitor {

    // MARK: - Initialization - Public

    /// Creates the default document visitor.
    public init() {}

    // MARK: - IDocumentVisitor

    /// Joins rendered block children with line breaks from the text visitor.
    public func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString {
        children.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
