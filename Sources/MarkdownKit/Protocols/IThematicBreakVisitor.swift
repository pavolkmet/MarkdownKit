import Foundation

/// Renders a Markdown thematic break.
public protocol IThematicBreakVisitor {
    /// Returns the rendered thematic break.
    mutating func visit() -> AttributedString
}
