/// Identifies whether a link came from Markdown syntax or unmarked-link detection.
public enum MarkdownLinkSource {

    // MARK: - Cases

    /// A destination written with Markdown link or autolink syntax.
    case markdown

    /// A destination detected in otherwise ordinary text.
    case unmarked
}
