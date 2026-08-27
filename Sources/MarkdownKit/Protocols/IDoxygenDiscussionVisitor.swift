import Foundation

/// Renders the contents of a Doxygen discussion directive.
public protocol IDoxygenDiscussionVisitor {
    /// Returns the rendered discussion directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
