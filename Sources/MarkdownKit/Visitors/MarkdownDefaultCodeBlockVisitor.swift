import Foundation

/// The default code-block visitor, which preserves code as ordinary attributed text.
public struct MarkdownDefaultCodeBlockVisitor: ICodeBlockVisitor {

    // MARK: - Initialization - Public

    /// Creates the default code-block visitor.
    public init() {}

    // MARK: - ICodeBlockVisitor

    /// Renders the block's code through the text visitor.
    public func visit(code: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: code)
    }
}
