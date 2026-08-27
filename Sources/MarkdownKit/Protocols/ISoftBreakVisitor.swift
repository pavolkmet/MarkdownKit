import Foundation

/// Renders a soft line break from Markdown source.
public protocol ISoftBreakVisitor {
    /// Returns the rendered soft break.
    mutating func visit(visitor: inout any ITextVisitor) -> AttributedString
}
