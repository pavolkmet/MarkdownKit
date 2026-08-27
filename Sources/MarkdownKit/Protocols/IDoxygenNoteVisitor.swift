import Foundation

/// Renders the contents of a Doxygen note directive.
public protocol IDoxygenNoteVisitor {
    /// Returns the rendered note directive.
    mutating func visit(children: [AttributedString]) -> AttributedString
}
