import SwiftUI

public extension View {

    // MARK: - Markdown Appearance - Public

    /// Sets the shared Markdown appearance inherited by descendant ``MarkdownText`` views.
    func markdownAppearance(_ appearance: MarkdownAppearance) -> some View {
        environment(\.markdownAppearance, appearance)
    }

    // MARK: - Markdown Elements - Public

    /// Appends element configurations inherited by descendant ``MarkdownText`` views.
    func markdownElements(_ elements: [MarkdownElement]) -> some View {
        transformEnvironment(\.markdownElementOverrides) { overrides in
            overrides.append(contentsOf: elements)
        }
    }

    /// Appends one element configuration inherited by descendant ``MarkdownText`` views.
    func markdownElement(_ element: MarkdownElement) -> some View {
        markdownElements([element])
    }

    /// Configures plain Markdown text in descendant ``MarkdownText`` views.
    func markdownText(_ configuration: MarkdownElementConfiguration<MarkdownTextAppearance, any ITextVisitor>) -> some View {
        markdownElement(.text(configuration))
    }

    /// Configures links in descendant ``MarkdownText`` views.
    func markdownLink(_ configuration: MarkdownElementConfiguration<MarkdownTextAppearance, any ILinkVisitor>) -> some View {
        markdownElement(.link(configuration))
    }

    /// Configures strong emphasis in descendant ``MarkdownText`` views.
    func markdownStrong(_ configuration: MarkdownElementConfiguration<MarkdownTextAppearance, any IStrongVisitor>) -> some View {
        markdownElement(.strong(configuration))
    }

    /// Configures emphasis in descendant ``MarkdownText`` views.
    func markdownEmphasis(_ configuration: MarkdownElementConfiguration<MarkdownTextAppearance, any IEmphasisVisitor>) -> some View {
        markdownElement(.emphasis(configuration))
    }

    /// Configures headings in descendant ``MarkdownText`` views.
    func markdownHeading(_ configuration: MarkdownElementConfiguration<MarkdownHeadingAppearance, any IHeadingVisitor>) -> some View {
        markdownElement(.heading(configuration))
    }

    /// Configures strikethrough text in descendant ``MarkdownText`` views.
    func markdownStrikethrough(_ configuration: MarkdownElementConfiguration<MarkdownTextAppearance, any IStrikethroughVisitor>) -> some View {
        markdownElement(.strikethrough(configuration))
    }

    /// Configures ordered lists in descendant ``MarkdownText`` views.
    func markdownOrderedList(_ configuration: MarkdownElementConfiguration<MarkdownListAppearance, any IOrderedListVisitor>) -> some View {
        markdownElement(.orderedList(configuration))
    }

    /// Configures unordered lists in descendant ``MarkdownText`` views.
    func markdownUnorderedList(_ configuration: MarkdownElementConfiguration<MarkdownListAppearance, any IUnorderedListVisitor>) -> some View {
        markdownElement(.unorderedList(configuration))
    }

    /// Adds a custom visitor to descendant ``MarkdownText`` views.
    func markdownCustomVisitor(_ visitor: any ICustomVisitor) -> some View {
        markdownElement(.custom(visitor))
    }
}
