import Foundation

/// Renders the contents of a Doxygen abstract directive.
public protocol IDoxygenAbstractVisitor {
    /// Returns the rendered abstract directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
