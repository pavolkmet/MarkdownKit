import Foundation

/// Shared appearances resolved by Markdown elements configured with `.default`.
///
/// Element support is controlled independently by ``MarkdownElement``. Appearances describe
/// presentation only and never enable or disable parsing behavior.
public struct MarkdownAppearance {

    // MARK: - Computed Properties - Public

    /// The platform-neutral default appearance.
    public static var `default`: MarkdownAppearance {
        let list = MarkdownListAppearance()

        return MarkdownAppearance(
            textAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultTextVisitor.default
            ),
            linkAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultLinkVisitor.default
            ),
            strongAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultStrongVisitor.default
            ),
            emphasisAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultEmphasisVisitor.default
            ),
            headingAppearance: .default,
            strikethroughAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultStrikethroughVisitor.default
            ),
            unorderedListAppearance: list,
            orderedListAppearance: list
        )
    }

    /// An appearance that adds no visual attributes while preserving enabled semantics.
    public static var plainText: MarkdownAppearance {
        MarkdownAppearance(textAppearance: .plain)
    }

    // MARK: - Properties - Public

    /// Attributes applied to all rendered text before element-specific attributes.
    public var text: MarkdownTextAppearance

    /// Attributes applied to links.
    public var link: MarkdownTextAppearance

    /// Attributes applied to strong content.
    public var strong: MarkdownTextAppearance

    /// Attributes applied to emphasized content.
    public var emphasis: MarkdownTextAppearance

    /// Level-aware heading attributes.
    public var heading: MarkdownHeadingAppearance

    /// Strikethrough attributes.
    public var strikethrough: MarkdownTextAppearance

    /// The unordered-list appearance.
    public var unorderedList: MarkdownListAppearance

    /// The ordered-list appearance.
    public var orderedList: MarkdownListAppearance

    // MARK: - Initialization - Public

    /// Creates shared appearances for default Markdown visitors.
    ///
    /// - Parameters:
    ///   - textAppearance: Appearance applied to every rendered character first.
    ///   - linkAppearance: Appearance for Markdown and detected unmarked links.
    ///   - strongAppearance: Appearance for strong content.
    ///   - emphasisAppearance: Appearance for emphasized content.
    ///   - headingAppearance: Appearance for heading levels one through six.
    ///   - strikethroughAppearance: Appearance for strikethrough content.
    ///   - unorderedListAppearance: Marker, item, and indentation settings for unordered lists.
    ///   - orderedListAppearance: Marker, item, and indentation settings for ordered lists.
    public init(
        textAppearance: MarkdownTextAppearance = .plain,
        linkAppearance: MarkdownTextAppearance = .plain,
        strongAppearance: MarkdownTextAppearance = .plain,
        emphasisAppearance: MarkdownTextAppearance = .plain,
        headingAppearance: MarkdownHeadingAppearance = .default,
        strikethroughAppearance: MarkdownTextAppearance = .plain,
        unorderedListAppearance: MarkdownListAppearance = MarkdownListAppearance(),
        orderedListAppearance: MarkdownListAppearance = MarkdownListAppearance()
    ) {
        text = textAppearance
        link = linkAppearance
        strong = strongAppearance
        emphasis = emphasisAppearance
        heading = headingAppearance
        strikethrough = strikethroughAppearance
        unorderedList = unorderedListAppearance
        orderedList = orderedListAppearance
    }

    /// Creates an appearance from raw containers for lower-level integrations.
    public init(
        text: AttributeContainer,
        link: AttributeContainer? = nil,
        strong: AttributeContainer? = nil,
        emphasis: AttributeContainer? = nil,
        heading: MarkdownHeadingAppearance? = nil,
        strikethrough: AttributeContainer? = nil,
        unorderedList: MarkdownListAppearance? = nil,
        orderedList: MarkdownListAppearance? = nil
    ) {
        self.init(
            textAppearance: MarkdownTextAppearance(container: text),
            linkAppearance: MarkdownTextAppearance(container: link ?? AttributeContainer()),
            strongAppearance: MarkdownTextAppearance(container: strong ?? AttributeContainer()),
            emphasisAppearance: MarkdownTextAppearance(container: emphasis ?? AttributeContainer()),
            headingAppearance: heading ?? .default,
            strikethroughAppearance: MarkdownTextAppearance(
                container: strikethrough ?? AttributeContainer()
            ),
            unorderedListAppearance: unorderedList ?? MarkdownListAppearance(),
            orderedListAppearance: orderedList ?? MarkdownListAppearance()
        )
    }
}
