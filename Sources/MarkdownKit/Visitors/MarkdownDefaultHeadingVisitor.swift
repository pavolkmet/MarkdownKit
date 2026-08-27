import Foundation

/// The level-aware implementation of ``IHeadingVisitor``.
public struct MarkdownDefaultHeadingVisitor: IHeadingVisitor {

    // MARK: - Properties - Public

    /// Level-aware attributes, or `nil` to leave headings as ordinary text.
    public let appearance: MarkdownHeadingAppearance?

    // MARK: - Initialization - Public

    /// Creates a heading visitor with a level-aware appearance.
    public init(appearance: MarkdownHeadingAppearance? = .default) {
        self.appearance = appearance
    }

    /// Creates a heading visitor that uses one container for every level.
    public init(container: AttributeContainer?) {
        self.appearance = container.map(MarkdownHeadingAppearance.init(container:))
    }

    // MARK: - IHeadingVisitor

    public func attributes(for text: String, level: Int) -> AttributeContainer? {
        appearance?.attributes(for: level)
    }
}
