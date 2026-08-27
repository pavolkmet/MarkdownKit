/// A focused rendering decision for one swift-markdown node or final processing step.
public enum MarkdownElement {

    // MARK: - Document

    /// Configures the root document and separation between its block children.
    case document(MarkdownVisitorConfiguration<any IDocumentVisitor>)

    // MARK: - Blocks

    /// Configures block quotes.
    case blockQuote(MarkdownVisitorConfiguration<any IBlockQuoteVisitor>)
    /// Configures fenced and indented code blocks.
    case codeBlock(MarkdownVisitorConfiguration<any ICodeBlockVisitor>)
    /// Configures custom block nodes.
    case customBlock(MarkdownVisitorConfiguration<any ICustomBlockVisitor>)
    /// Configures level-aware headings.
    case heading(MarkdownElementConfiguration<MarkdownHeadingAppearance, any IHeadingVisitor>)
    /// Configures thematic breaks.
    case thematicBreak(MarkdownVisitorConfiguration<any IThematicBreakVisitor>)
    /// Configures raw HTML blocks.
    case htmlBlock(MarkdownVisitorConfiguration<any IHTMLBlockVisitor>)
    /// Configures the content inside each list item.
    case listItem(MarkdownVisitorConfiguration<any IListItemVisitor>)
    /// Configures ordered-list markers, indentation, and layout.
    case orderedList(MarkdownElementConfiguration<MarkdownListAppearance, any IOrderedListVisitor>)
    /// Configures unordered-list markers, indentation, and layout.
    case unorderedList(MarkdownElementConfiguration<MarkdownListAppearance, any IUnorderedListVisitor>)
    /// Configures paragraph contents.
    case paragraph(MarkdownVisitorConfiguration<any IParagraphVisitor>)
    /// Configures block directives.
    case blockDirective(MarkdownVisitorConfiguration<any IBlockDirectiveVisitor>)

    // MARK: - Inline

    /// Configures inline code spans.
    case inlineCode(MarkdownVisitorConfiguration<any IInlineCodeVisitor>)
    /// Configures custom inline nodes.
    case customInline(MarkdownVisitorConfiguration<any ICustomInlineVisitor>)
    /// Configures emphasized text.
    case emphasis(MarkdownElementConfiguration<MarkdownTextAppearance, any IEmphasisVisitor>)
    /// Configures images, which render as their alternative text by default.
    case image(MarkdownVisitorConfiguration<any IImageVisitor>)
    /// Configures raw inline HTML.
    case inlineHTML(MarkdownVisitorConfiguration<any IInlineHTMLVisitor>)
    /// Configures explicit Markdown line breaks.
    case lineBreak(MarkdownVisitorConfiguration<any ILineBreakVisitor>)
    /// Configures Markdown links and detected unmarked links.
    case link(MarkdownElementConfiguration<MarkdownTextAppearance, any ILinkVisitor>)
    /// Configures soft line breaks.
    case softBreak(MarkdownVisitorConfiguration<any ISoftBreakVisitor>)
    /// Configures strongly emphasized text.
    case strong(MarkdownElementConfiguration<MarkdownTextAppearance, any IStrongVisitor>)
    /// Configures the base appearance of all emitted text.
    case text(MarkdownElementConfiguration<MarkdownTextAppearance, any ITextVisitor>)
    /// Configures strikethrough text.
    case strikethrough(MarkdownElementConfiguration<MarkdownTextAppearance, any IStrikethroughVisitor>)
    /// Configures symbol links.
    case symbolLink(MarkdownVisitorConfiguration<any ISymbolLinkVisitor>)
    /// Configures inline-attribute nodes.
    case inlineAttributes(MarkdownVisitorConfiguration<any IInlineAttributesVisitor>)

    // MARK: - Tables

    /// Configures complete tables.
    case table(MarkdownVisitorConfiguration<any ITableVisitor>)
    /// Configures table header sections.
    case tableHead(MarkdownVisitorConfiguration<any ITableHeadVisitor>)
    /// Configures table body sections.
    case tableBody(MarkdownVisitorConfiguration<any ITableBodyVisitor>)
    /// Configures table rows.
    case tableRow(MarkdownVisitorConfiguration<any ITableRowVisitor>)
    /// Configures table cells.
    case tableCell(MarkdownVisitorConfiguration<any ITableCellVisitor>)

    // MARK: - Doxygen

    /// Configures Doxygen discussion directives.
    case doxygenDiscussion(MarkdownVisitorConfiguration<any IDoxygenDiscussionVisitor>)
    /// Configures Doxygen note directives.
    case doxygenNote(MarkdownVisitorConfiguration<any IDoxygenNoteVisitor>)
    /// Configures Doxygen abstract directives.
    case doxygenAbstract(MarkdownVisitorConfiguration<any IDoxygenAbstractVisitor>)
    /// Configures Doxygen parameter directives.
    case doxygenParameter(MarkdownVisitorConfiguration<any IDoxygenParameterVisitor>)
    /// Configures Doxygen return-value directives.
    case doxygenReturns(MarkdownVisitorConfiguration<any IDoxygenReturnsVisitor>)

    // MARK: - Final Processing

    /// Adds an application-specific post-processing visitor.
    case custom(any ICustomVisitor)

    // MARK: - Computed Properties - Public

    /// Every standard MarkdownKit element backed by its matching default visitor.
    public static var defaults: [MarkdownElement] {
        [
            .document(.default),
            .blockQuote(.default),
            .codeBlock(.default),
            .customBlock(.default),
            .heading(.default),
            .thematicBreak(.default),
            .htmlBlock(.default),
            .listItem(.default),
            .orderedList(.default),
            .unorderedList(.default),
            .paragraph(.default),
            .blockDirective(.default),
            .inlineCode(.default),
            .customInline(.default),
            .emphasis(.default),
            .image(.default),
            .inlineHTML(.default),
            .lineBreak(.default),
            .link(.default),
            .softBreak(.default),
            .strong(.default),
            .text(.default),
            .strikethrough(.default),
            .symbolLink(.default),
            .inlineAttributes(.default),
            .table(.default),
            .tableHead(.default),
            .tableBody(.default),
            .tableRow(.default),
            .tableCell(.default),
            .doxygenDiscussion(.default),
            .doxygenNote(.default),
            .doxygenAbstract(.default),
            .doxygenParameter(.default),
            .doxygenReturns(.default),
        ]
    }
}
