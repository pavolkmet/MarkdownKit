import Foundation

/// Renders the children of an ordered or unordered list item.
public protocol IListItemVisitor {
    /// Returns the rendered list-item content.
    mutating func visit(children: [MarkdownListItemChild], appearance: MarkdownListAppearance?, visitor: inout any ITextVisitor) -> AttributedString
}
