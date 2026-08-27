import Foundation

/// The default inline-code visitor, which preserves code as ordinary attributed text.
public struct MarkdownDefaultInlineCodeVisitor: IInlineCodeVisitor {

    // MARK: - Initialization - Public

    /// Creates the default inline-code visitor.
    public init() {}

    // MARK: - IInlineCodeVisitor

    /// Renders code through the text visitor.
    public func visit(code: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: code)
    }
}
