import Foundation

/// The platform-neutral semantic implementation of ``IStrikethroughVisitor``.
public struct MarkdownDefaultStrikethroughVisitor: IStrikethroughVisitor {

    // MARK: - Computed Properties - Public

    /// The platform-neutral semantic attributes for strikethrough content.
    public static var `default`: AttributeContainer {
        var container = AttributeContainer()
        container.inlinePresentationIntent = .strikethrough
        return container
    }

    // MARK: - Properties - Public

    /// Attributes applied to strikethrough content, or `nil` for ordinary text.
    public let container: AttributeContainer?

    // MARK: - Initialization - Public

    /// Creates a strikethrough visitor with optional attributes.
    public init(container: AttributeContainer? = MarkdownDefaultStrikethroughVisitor.default) {
        self.container = container
    }

    // MARK: - IStrikethroughVisitor

    public func attributes(for text: String) -> AttributeContainer? {
        container
    }
}
