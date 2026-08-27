import Foundation

/// The default list-item visitor, which applies item attributes to non-list children.
public struct MarkdownDefaultListItemVisitor: IListItemVisitor {

    // MARK: - Initialization - Public

    /// Creates the default list-item visitor.
    public init() {}

    // MARK: - IListItemVisitor

    /// Styles ordinary children and joins all children with line breaks.
    public func visit(children: [MarkdownListItemChild], appearance: MarkdownListAppearance?, visitor: inout any ITextVisitor) -> AttributedString {
        let renderedChildren = children.map { child in
            guard child.isList == false, let appearance else {
                return child.attributedString
            }

            var result = child.attributedString
            result.mergeAttributes(appearance.item)
            return result
        }

        return renderedChildren.joined(
            separator: visitor.visit(text: "\n")
        )
    }
}
