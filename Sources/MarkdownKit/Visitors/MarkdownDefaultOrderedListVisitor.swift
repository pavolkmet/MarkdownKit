import Foundation

/// The default ordered-list visitor, which adds numeric markers and indentation.
public struct MarkdownDefaultOrderedListVisitor: IOrderedListVisitor {

    // MARK: - Properties - Public

    /// Marker, item, and indentation settings, or `nil` for plain item content.
    public let appearance: MarkdownListAppearance?

    // MARK: - Initialization - Public

    /// Creates an ordered-list visitor with an optional appearance.
    public init(appearance: MarkdownListAppearance? = MarkdownListAppearance()) {
        self.appearance = appearance
    }

    // MARK: - IOrderedListVisitor

    /// Adds numeric markers to items and joins them with line breaks.
    public func visit(items: [AttributedString], startIndex: UInt, depth: Int, visitor: inout any ITextVisitor) -> AttributedString {
        let renderedItems = items.enumerated().map { offset, item in
            guard let appearance else {
                return item
            }

            let indentation = String(
                repeating: " ",
                count: max(0, appearance.indentation) * depth
            )
            var marker = visitor.visit(
                text: "\(indentation)\(Int(startIndex) + offset). "
            )
            marker.mergeAttributes(appearance.marker)
            marker.append(item)
            return marker
        }

        return renderedItems.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
