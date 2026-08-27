import Foundation

/// The native semantic implementation of ``IStrongVisitor``.
public struct MarkdownDefaultStrongVisitor: IStrongVisitor {

    // MARK: - Computed Properties - Public

    /// The platform-neutral semantic attributes for strongly emphasized content.
    public static var `default`: AttributeContainer {
        var attributes = AttributeContainer()
        attributes.inlinePresentationIntent = .stronglyEmphasized
        return attributes
    }

    // MARK: - Properties - Public

    /// Attributes applied to strong content, or `nil` to leave it as ordinary text.
    public let container: AttributeContainer?

    // MARK: - Initialization - Public

    /// Creates a strong visitor with optional attributes.
    public init(container: AttributeContainer? = MarkdownDefaultStrongVisitor.default) {
        self.container = container
    }

    // MARK: - IStrongVisitor

    public func attributes(for text: String) -> AttributeContainer? {
        container
    }
}
