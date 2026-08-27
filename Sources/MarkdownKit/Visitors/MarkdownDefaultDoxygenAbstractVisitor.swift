import Foundation

/// The default Doxygen abstract visitor, which preserves its rendered children.
public struct MarkdownDefaultDoxygenAbstractVisitor: IDoxygenAbstractVisitor {

    // MARK: - Initialization - Public

    /// Creates the default Doxygen abstract visitor.
    public init() {}

    // MARK: - IDoxygenAbstractVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
