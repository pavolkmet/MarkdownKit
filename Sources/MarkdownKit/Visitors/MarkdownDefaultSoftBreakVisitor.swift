import Foundation

/// The default soft-break visitor.
public struct MarkdownDefaultSoftBreakVisitor: ISoftBreakVisitor {

    // MARK: - Initialization - Public

    /// Creates the default soft-break visitor.
    public init() {}

    // MARK: - ISoftBreakVisitor

    /// Renders a newline through the text visitor.
    public func visit(visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: "\n")
    }
}
