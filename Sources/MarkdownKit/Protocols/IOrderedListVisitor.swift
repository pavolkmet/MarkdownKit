import Foundation

/// Renders an ordered list and its numeric markers.
public protocol IOrderedListVisitor {
    /// The marker, item, and indentation appearance, or `nil` for plain item content.
    var appearance: MarkdownListAppearance? { get }

    /// Returns the rendered ordered list.
    mutating func visit(items: [AttributedString], startIndex: UInt, depth: Int, visitor: inout any ITextVisitor) -> AttributedString
}
