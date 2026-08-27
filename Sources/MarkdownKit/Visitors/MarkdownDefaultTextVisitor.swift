import Foundation

/// The platform-neutral implementation of ``ITextVisitor``.
public struct MarkdownDefaultTextVisitor: ITextVisitor {

    // MARK: - Computed Properties - Public

    /// The platform-neutral default text attributes.
    public static var `default`: AttributeContainer {
        AttributeContainer()
    }

    // MARK: - Properties - Public

    /// Base attributes applied to every emitted text fragment.
    public let container: AttributeContainer

    // MARK: - Initialization - Public

    /// Creates a text visitor with base attributes.
    public init(container: AttributeContainer = MarkdownDefaultTextVisitor.default) {
        self.container = container
    }

    // MARK: - ITextVisitor

    public func attributes(for text: String) -> AttributeContainer {
        container
    }
}
