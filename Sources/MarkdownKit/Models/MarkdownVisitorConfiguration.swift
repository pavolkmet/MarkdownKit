/// Selects how a structural Markdown element is rendered.
public enum MarkdownVisitorConfiguration<Visitor> {
    /// Removes the element-specific behavior while keeping its readable content.
    case disabled

    /// Uses the matching MarkdownKit default visitor.
    case `default`

    /// Replaces the matching default visitor completely.
    case visitor(Visitor)
}
