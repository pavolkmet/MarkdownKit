import Foundation

/// The default Doxygen discussion visitor, which preserves its rendered children.
public struct MarkdownDefaultDoxygenDiscussionVisitor: IDoxygenDiscussionVisitor {

    // MARK: - Initialization - Public

    /// Creates the default Doxygen discussion visitor.
    public init() {}

    // MARK: - IDoxygenDiscussionVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
