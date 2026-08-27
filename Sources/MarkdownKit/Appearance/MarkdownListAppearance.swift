import Foundation

/// Attributes and indentation used when rendering list items as plain characters.
public struct MarkdownListAppearance {

    // MARK: - Properties - Public

    /// Attributes applied to the indentation, marker, and separating space.
    public let marker: AttributeContainer

    /// Attributes applied to each list item's content.
    public let item: AttributeContainer

    /// The number of spaces inserted for each nesting level.
    public let indentation: Int

    // MARK: - Initialization - Public

    /// Creates a list appearance.
    ///
    /// - Parameters:
    ///   - marker: Attributes for bullets, numbers, indentation, and marker spacing.
    ///   - item: Attributes for list item content.
    ///   - indentation: Spaces per nesting level. Negative values are rendered as zero.
    public init(
        marker: AttributeContainer = AttributeContainer(),
        item: AttributeContainer = AttributeContainer(),
        indentation: Int = 2
    ) {
        self.marker = marker
        self.item = item
        self.indentation = indentation
    }
}
