import Foundation

/// The default image visitor, which renders readable alternative text.
public struct MarkdownDefaultImageVisitor: IImageVisitor {

    // MARK: - Initialization - Public

    /// Creates the default image visitor.
    public init() {}

    // MARK: - IImageVisitor

    /// Renders the image's alternative text through the text visitor.
    public func visit(altText: String, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: altText)
    }
}
