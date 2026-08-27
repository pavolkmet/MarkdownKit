import Foundation

/// Renders the contents of a Doxygen parameter directive.
public protocol IDoxygenParameterVisitor {
    /// Returns the rendered parameter directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
