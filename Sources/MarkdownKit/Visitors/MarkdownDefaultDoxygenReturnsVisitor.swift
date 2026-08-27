import Foundation

/// The default Doxygen returns visitor, which preserves its rendered children.
public struct MarkdownDefaultDoxygenReturnsVisitor: IDoxygenReturnsVisitor {

    // MARK: - Initialization - Public

    /// Creates the default Doxygen returns visitor.
    public init() {}

    // MARK: - IDoxygenReturnsVisitor

    /// Concatenates the directive's rendered children.
    public func visit(children: [AttributedString]) -> AttributedString {
        children.concatenated
    }
}
