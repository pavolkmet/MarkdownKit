/// Selects how an appearance-capable Markdown element is rendered.
public enum MarkdownElementConfiguration<Appearance, Visitor> {
    /// Removes the element-specific behavior while keeping its readable content.
    case disabled

    /// Uses the default visitor with the shared ``MarkdownAppearance`` value.
    case `default`

    /// Uses the default visitor with an element-specific appearance override.
    case appearance(Appearance)

    /// Replaces the element-specific default visitor completely.
    case visitor(Visitor)
}
