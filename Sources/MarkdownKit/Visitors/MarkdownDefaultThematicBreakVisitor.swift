import Foundation

/// The default thematic-break visitor, which emits no visible characters.
public struct MarkdownDefaultThematicBreakVisitor: IThematicBreakVisitor {

    // MARK: - Initialization - Public

    /// Creates the default thematic-break visitor.
    public init() {}

    // MARK: - IThematicBreakVisitor

    /// Returns an empty attributed string.
    public func visit() -> AttributedString {
        AttributedString()
    }
}
