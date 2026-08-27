import Foundation

/// The default symbol-link visitor, which renders its destination as text.
public struct MarkdownDefaultSymbolLinkVisitor: ISymbolLinkVisitor {

    // MARK: - Initialization - Public

    /// Creates the default symbol-link visitor.
    public init() {}

    // MARK: - ISymbolLinkVisitor

    /// Renders the symbol destination through the text visitor.
    public func visit(destination: String?, visitor: inout any ITextVisitor) -> AttributedString {
        visitor.visit(text: destination ?? "")
    }
}
