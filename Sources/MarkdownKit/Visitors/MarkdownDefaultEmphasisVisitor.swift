import Foundation

/// The native semantic implementation of ``IEmphasisVisitor``.
public struct MarkdownDefaultEmphasisVisitor: IEmphasisVisitor {

    // MARK: - Computed Properties - Public

    /// The platform-neutral semantic attributes for emphasized content.
    public static var `default`: AttributeContainer {
        var attributes = AttributeContainer()
        attributes.inlinePresentationIntent = .emphasized
        return attributes
    }

    // MARK: - Properties - Public

    /// Attributes applied to emphasized content, or `nil` to leave it as ordinary text.
    public let container: AttributeContainer?

    // MARK: - Initialization - Public

    /// Creates an emphasis visitor with optional attributes.
    public init(container: AttributeContainer? = MarkdownDefaultEmphasisVisitor.default) {
        self.container = container
    }

    // MARK: - IEmphasisVisitor

    public func attributes(for text: String) -> AttributeContainer? {
        container
    }
}
