import Foundation

/// The default Doxygen note visitor, which preserves its rendered children.
public struct MarkdownDefaultDoxygenNoteVisitor: IDoxygenNoteVisitor {

    // MARK: - Initialization - Public

    /// Creates the default Doxygen note visitor.
    public init() {}

    // MARK: - IDoxygenNoteVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
