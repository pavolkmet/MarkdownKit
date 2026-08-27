import Foundation

/// The default inline-HTML visitor, which preserves raw HTML as text.
public struct MarkdownDefaultInlineHTMLVisitor: IInlineHTMLVisitor {

    // MARK: - Initialization - Public

    /// Creates the default inline-HTML visitor.
    public init() {}

    // MARK: - IInlineHTMLVisitor

    /// Renders raw HTML through the text visitor.
    public func visit(rawHTML: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: rawHTML)
    }
}
