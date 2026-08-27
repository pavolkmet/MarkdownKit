import Foundation

/// A rendered list-item child and whether it represents a nested list.
public struct MarkdownListItemChild {

    // MARK: - Properties - Public

    /// The rendered child content.
    public let attributedString: AttributedString

    /// Whether the child is a nested ordered or unordered list.
    public let isList: Bool

    // MARK: - Initialization - Public

    /// Creates a rendered list-item child.
    public init(attributedString: AttributedString, isList: Bool) {
        self.attributedString = attributedString
        self.isList = isList
    }
}
