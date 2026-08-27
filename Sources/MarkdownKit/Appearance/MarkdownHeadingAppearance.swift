import Foundation

/// Attribute containers for Markdown heading levels one through six.
public struct MarkdownHeadingAppearance {

    // MARK: - Properties - Public

    /// Attributes for a level-one heading.
    public let level1: AttributeContainer

    /// Attributes for a level-two heading.
    public let level2: AttributeContainer

    /// Attributes for a level-three heading.
    public let level3: AttributeContainer

    /// Attributes for a level-four heading.
    public let level4: AttributeContainer

    /// Attributes for a level-five heading.
    public let level5: AttributeContainer

    /// Attributes for a level-six heading.
    public let level6: AttributeContainer

    // MARK: - Computed Properties - Public

    /// A platform-neutral appearance that adds no heading attributes.
    public static var `default`: MarkdownHeadingAppearance {
        MarkdownHeadingAppearance(container: AttributeContainer())
    }

    // MARK: - Initialization - Public

    /// Creates a level-aware heading appearance.
    public init(
        level1: AttributeContainer,
        level2: AttributeContainer,
        level3: AttributeContainer,
        level4: AttributeContainer,
        level5: AttributeContainer,
        level6: AttributeContainer
    ) {
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
        self.level4 = level4
        self.level5 = level5
        self.level6 = level6
    }

    /// Creates an appearance that uses one container for all heading levels.
    ///
    /// - Parameter container: Attributes returned for every heading level.
    public init(container: AttributeContainer) {
        self.init(
            level1: container,
            level2: container,
            level3: container,
            level4: container,
            level5: container,
            level6: container
        )
    }

    // MARK: - Helper Methods - Public

    /// Returns attributes for a heading level, clamping values outside `1...6`.
    public func attributes(for level: Int) -> AttributeContainer {
        switch min(max(level, 1), 6) {
        case 1: level1
        case 2: level2
        case 3: level3
        case 4: level4
        case 5: level5
        default: level6
        }
    }
}
