import Foundation

/// The default explicit line-break visitor.
public struct MarkdownDefaultLineBreakVisitor: ILineBreakVisitor {

    // MARK: - Initialization - Public

    /// Creates the default line-break visitor.
    public init() {}

    // MARK: - ILineBreakVisitor

    /// Renders a newline through the text visitor.
    public func visit(visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: "\n")
    }
}
