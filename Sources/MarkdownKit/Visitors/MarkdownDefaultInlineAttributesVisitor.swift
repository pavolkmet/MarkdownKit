import Foundation

/// The default inline-attributes visitor, which preserves its rendered children.
public struct MarkdownDefaultInlineAttributesVisitor: IInlineAttributesVisitor {

    // MARK: - Initialization - Public

    /// Creates the default inline-attributes visitor.
    public init() {}

    // MARK: - IInlineAttributesVisitor

    /// Concatenates the rendered children without interpreting the declaration.
    public func visit(children: [AttributedString], attributes: String) -> AttributedString {
        children.concatenated
    }
}
