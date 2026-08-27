import Foundation

/// The default custom-inline visitor, which preserves its text.
public struct MarkdownDefaultCustomInlineVisitor: ICustomInlineVisitor {

    // MARK: - Initialization - Public

    /// Creates the default custom-inline visitor.
    public init() {}

    // MARK: - ICustomInlineVisitor

    /// Renders custom inline text through the text visitor.
    public func visit(text: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: text)
    }
}
