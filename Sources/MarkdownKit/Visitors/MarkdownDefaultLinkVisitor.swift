import Foundation

/// The platform-neutral implementation of ``ILinkVisitor``.
public struct MarkdownDefaultLinkVisitor: ILinkVisitor {

    // MARK: - Computed Properties - Public

    /// The platform-neutral default link attributes.
    public static var `default`: AttributeContainer {
        AttributeContainer()
    }

    public var shouldDetectUnmarkedLinks: Bool { container != nil }

    // MARK: - Properties - Public

    /// Attributes applied to links, or `nil` to remove link behavior.
    public let container: AttributeContainer?

    // MARK: - Initialization - Public

    /// Creates a link visitor with optional attributes.
    public init(container: AttributeContainer? = MarkdownDefaultLinkVisitor.default) {
        self.container = container
    }

    // MARK: - ILinkVisitor

    public func attributes(for text: String, destination: URL, source: MarkdownLinkSource) -> AttributeContainer? {
        container
    }
}
