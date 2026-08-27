import Foundation

/// The default custom-block visitor, which preserves its rendered children.
public struct MarkdownDefaultCustomBlockVisitor: ICustomBlockVisitor {

    // MARK: - Initialization - Public

    /// Creates the default custom-block visitor.
    public init() {}

    // MARK: - ICustomBlockVisitor

    /// Concatenates the custom block's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
