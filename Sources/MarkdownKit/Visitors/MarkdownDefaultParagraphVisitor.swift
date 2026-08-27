import Foundation

/// The default paragraph visitor, which preserves its rendered inline children.
public struct MarkdownDefaultParagraphVisitor: IParagraphVisitor {

    // MARK: - Initialization - Public

    /// Creates the default paragraph visitor.
    public init() {}

    // MARK: - IParagraphVisitor

    /// Concatenates the paragraph's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
