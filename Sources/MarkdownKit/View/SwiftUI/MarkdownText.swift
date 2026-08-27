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
/// ``SwiftUI/EnvironmentValues/openURL`` action:
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
    }

    // MARK: - Properties - Private

    @Environment(\.markdownAppearance) private var appearance
    @Environment(\.markdownElementOverrides) private var environmentElements

    private let content: Content
    private let elements: [MarkdownElement]

    // MARK: - Initialization - Public

    /// Creates a view that parses and renders Markdown source text.
    ///
    /// - Parameters:
    ///   - text: The Markdown source to render.
    ///   - elements: The baseline element configurations. Later environment overrides take precedence.
    public init(text: String, elements: [MarkdownElement] = MarkdownElement.defaults) {
        content = .text(text)
        self.elements = elements
    }

    /// Creates a view that renders an already parsed Markdown document.
    ///
    /// - Parameters:
    ///   - document: The parsed Markdown document to render.
    ///   - elements: The baseline element configurations. Later environment overrides take precedence.
    public init(document: Document, elements: [MarkdownElement] = MarkdownElement.defaults) {
        content = .document(document)
        self.elements = elements
    }

    // MARK: - View

    public var body: some View {
        let string: AttributedString = {
            let renderer = MarkdownRenderer(
                elements: elements + environmentElements,
                appearance: appearance
            )
            switch content {
            case .text(let text):
                return renderer.attributedString(from: text)
            case .document(let document):
                return renderer.attributedString(from: document)
            }
        }()
        Text(string)
    }
}
