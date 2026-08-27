import Foundation

/// Renders the contents of a Doxygen returns directive.
public protocol IDoxygenReturnsVisitor {
    /// Returns the rendered returns directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
