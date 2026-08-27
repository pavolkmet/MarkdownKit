import Foundation

/// Renders an explicit Markdown line break.
public protocol ILineBreakVisitor {
    /// Returns the rendered line break.
    mutating func visit(visitor: inout any ITextVisitor) -> AttributedString
}
