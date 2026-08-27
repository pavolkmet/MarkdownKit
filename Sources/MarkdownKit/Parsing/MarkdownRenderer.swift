import Foundation
import Markdown

/// A reusable renderer that converts Markdown source or documents into attributed strings.
public struct MarkdownRenderer {

    // MARK: - Properties - Private

    private let renderDocument: (Document) -> AttributedString

    // MARK: - Initialization - Public

    /// Creates a renderer from the default elements and appearance.
    public init() {
        self.init(
            defaultElementsOverriddenBy: [],
            appearance: .default
        )
    }

    /// Creates a renderer from the default elements and a shared appearance.
    public init(appearance: MarkdownAppearance) {
        self.init(
            defaultElementsOverriddenBy: [],
            appearance: appearance
        )
    }

    /// Creates a renderer from focused element decisions and shared appearances.
    public init(elements: [MarkdownElement] = MarkdownElement.defaults, appearance: MarkdownAppearance = .default) {
        self.init(
            visitors: MarkdownElement.visitors(
                from: elements,
                appearance: appearance
            )
        )
    }

    /// Creates a renderer backed by individually replaceable element visitors.
    public init(visitors: MarkdownMarkupVisitors) {
        let visitor = MarkdownAttributedMarkupVisitor(visitors: visitors)

        self.renderDocument = { document in
            var visitor = visitor
            return visitor.visit(document)
        }
    }

    /// Creates a renderer that completely replaces MarkdownKit's visitor.
    public init<Visitor: MarkupVisitor>(visitor: Visitor) where Visitor.Result == AttributedString {
        self.renderDocument = { document in
            var visitor = visitor
            return visitor.visit(document)
        }
    }

    // MARK: - Initialization - Internal

    init(defaultElementsOverriddenBy overrides: [MarkdownElement], appearance: MarkdownAppearance) {
        self.init(
            visitors: MarkdownElement.visitors(
                defaultElementsOverriddenBy: overrides,
                appearance: appearance
            )
        )
    }

    // MARK: - Helper Methods - Public

    /// Parses Markdown source and returns its rendered attributed string.
    public func attributedString(from text: String) -> AttributedString {
        attributedString(from: Document(parsing: text))
    }

    /// Renders a reusable document without parsing its source again.
    public func attributedString(from document: MarkdownDocument) -> AttributedString {
        attributedString(from: document.document)
    }

    /// Renders an already parsed Markdown document.
    public func attributedString(from document: Document) -> AttributedString {
        renderDocument(document)
    }
}
