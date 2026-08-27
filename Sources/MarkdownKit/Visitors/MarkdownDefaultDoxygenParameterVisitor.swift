import Foundation

/// The default Doxygen parameter visitor, which preserves its rendered children.
public struct MarkdownDefaultDoxygenParameterVisitor: IDoxygenParameterVisitor {

    // MARK: - Initialization - Public

    /// Creates the default Doxygen parameter visitor.
    public init() {}

    // MARK: - IDoxygenParameterVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
