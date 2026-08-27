import Foundation

/// Attributes used to present a text-producing Markdown element.
public struct MarkdownTextAppearance {

    // MARK: - Computed Properties - Public

    /// An appearance that does not add any attributes.
    public static var plain: MarkdownTextAppearance {
        MarkdownTextAppearance()
    }

    // MARK: - Properties - Public

    /// The Foundation attributes applied by the corresponding default visitor.
    public var container: AttributeContainer

    // MARK: - Initialization - Public

    /// Creates a text appearance from a Foundation attribute container.
    ///
    /// - Parameter container: Attributes applied by the matching default visitor.
    public init(container: AttributeContainer = AttributeContainer()) {
        self.container = container
    }

    // MARK: - Helper Methods - Public

    /// Merges additional attributes into this appearance.
    public mutating func merge(_ container: AttributeContainer) {
        self.container.merge(container)
    }

    /// Returns a copy with additional attributes merged into it.
    public func merging(_ container: AttributeContainer) -> MarkdownTextAppearance {
        var appearance = self
        appearance.merge(container)
        return appearance
    }
}
