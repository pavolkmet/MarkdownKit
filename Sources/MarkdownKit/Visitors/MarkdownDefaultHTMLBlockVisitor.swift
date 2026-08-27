import Foundation

/// The default HTML-block visitor, which preserves raw HTML as text.
public struct MarkdownDefaultHTMLBlockVisitor: IHTMLBlockVisitor {

    // MARK: - Initialization - Public

    /// Creates the default HTML-block visitor.
    public init() {}

    // MARK: - IHTMLBlockVisitor

    /// Renders raw HTML through the text visitor.
    public func visit(rawHTML: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: rawHTML)
    }
}
