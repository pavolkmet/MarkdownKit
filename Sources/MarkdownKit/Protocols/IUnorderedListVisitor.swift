import Foundation

/// Renders an unordered list and its bullet markers.
public protocol IUnorderedListVisitor {
    /// The marker, item, and indentation appearance, or `nil` for plain item content.
    var appearance: MarkdownListAppearance? { get }

    /// Returns the rendered unordered list.
    mutating func visit(items: [AttributedString], depth: Int, visitor: inout any ITextVisitor) -> AttributedString
}
