import Foundation

/// The default unordered-list visitor, which adds bullet markers and indentation.
public struct MarkdownDefaultUnorderedListVisitor: IUnorderedListVisitor {

    // MARK: - Properties - Public

    /// Marker, item, and indentation settings, or `nil` for plain item content.
    public let appearance: MarkdownListAppearance?

    // MARK: - Initialization - Public

    /// Creates an unordered-list visitor with an optional appearance.
    public init(appearance: MarkdownListAppearance? = MarkdownListAppearance()) {
        self.appearance = appearance
    }

    // MARK: - IUnorderedListVisitor

    /// Adds bullet markers to items and joins them with line breaks.
    public func visit(items: [AttributedString], depth: Int, visitor: inout any ITextVisitor) -> AttributedString {
        let renderedItems = items.map { item in
            guard let appearance else {
                return item
            }

            let indentation = String(
                repeating: " ",
                count: max(0, appearance.indentation) * depth
            )
            var marker = visitor.visit(text: "\(indentation)• ")
            marker.mergeAttributes(appearance.marker)
            marker.append(item)
            return marker
        }

        return renderedItems.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
