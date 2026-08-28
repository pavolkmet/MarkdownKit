import Markdown
import SwiftUI

/// A SwiftUI view that renders Markdown as native text with configurable visitors and appearance.
///
/// Use the string initializer for source text:
///
/// ```swift
/// MarkdownText(text: "Read **more** at [Swift.org](https://swift.org).")
/// ```
///
/// Links are interactive by default. To handle a tapped URL yourself, provide an
/// `openURL` environment action:
///
/// ```swift
/// MarkdownText(text: "Open [Settings](app://settings).")
///     .environment(\.openURL, OpenURLAction { url in
///         handle(url)
///         return .handled
///     })
/// ```
public struct MarkdownText: View {

    // MARK: - Content

    private enum Content {
        case text(String)
        case document(Document)
        case markdownDocument(MarkdownDocument)
    }

    // MARK: - Elements

    private enum Elements {
        case `default`
        case explicit([MarkdownElement])
    }

    // MARK: - Properties - Private

    @Environment(\.markdownAppearance) private var appearance
    @Environment(\.markdownElementOverrides) private var environmentElements

    private let content: Content
    private let elements: Elements

    // MARK: - Initialization - Public

    /// Creates a view that parses and renders Markdown source text with the default elements.
    ///
    /// - Parameter text: The Markdown source to render.
    public init(text: String) {
        self.content = .text(text)
        self.elements = .default
    }

    /// Creates a view that parses and renders Markdown source text with explicit elements.
    ///
    /// - Parameters:
    ///   - text: The Markdown source to render.
    ///   - elements: The baseline element configurations. Later environment overrides take precedence.
    public init(text: String, elements: [MarkdownElement] = MarkdownElement.defaults) {
        self.content = .text(text)
        self.elements = .explicit(elements)
    }

    /// Creates a view that renders an already parsed Markdown document with the default elements.
    ///
    /// - Parameter document: The parsed Markdown document to render.
    public init(document: Document) {
        self.content = .document(document)
        self.elements = .default
    }

    /// Creates a view that renders an already parsed Markdown document with explicit elements.
    ///
    /// - Parameters:
    ///   - document: The parsed Markdown document to render.
    ///   - elements: The baseline element configurations. Later environment overrides take precedence.
    public init(document: Document, elements: [MarkdownElement] = MarkdownElement.defaults) {
        self.content = .document(document)
        self.elements = .explicit(elements)
    }

    /// Creates a view that renders a reusable MarkdownKit document with the default elements.
    ///
    /// - Parameter document: The reusable document to render with the current environment appearance.
    public init(document: MarkdownDocument) {
        self.content = .markdownDocument(document)
        self.elements = .default
    }

    /// Creates a view that renders a reusable MarkdownKit document with explicit elements.
    ///
    /// - Parameters:
    ///   - document: The reusable document to render with the current environment appearance.
    ///   - elements: The baseline element configurations. Later environment overrides take precedence.
    public init(document: MarkdownDocument, elements: [MarkdownElement] = MarkdownElement.defaults) {
        self.content = .markdownDocument(document)
        self.elements = .explicit(elements)
    }

    // MARK: - View

    public var body: some View {
        let string: AttributedString = {
            let renderer: MarkdownRenderer
            switch elements {
            case .default:
                renderer = MarkdownRenderer(
                    defaultElementsOverriddenBy: environmentElements,
                    appearance: appearance
                )
            case .explicit(let values):
                renderer = MarkdownRenderer(
                    elements: values + environmentElements,
                    appearance: appearance
                )
            }

            switch content {
            case .text(let text):
                return renderer.attributedString(from: text)
            case .document(let document):
                return renderer.attributedString(from: document)
            case .markdownDocument(let document):
                return renderer.attributedString(from: document)
            }
        }()
        Text(string)
    }
}
