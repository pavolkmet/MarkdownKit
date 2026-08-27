import Foundation

/// The default block-directive visitor, which preserves its rendered children.
public struct MarkdownDefaultBlockDirectiveVisitor: IBlockDirectiveVisitor {

    // MARK: - Initialization - Public

    /// Creates the default block-directive visitor.
    public init() {}

    // MARK: - IBlockDirectiveVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
