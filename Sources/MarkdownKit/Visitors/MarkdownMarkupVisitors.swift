import Foundation

/// The complete set of focused visitors used by ``MarkdownAttributedMarkupVisitor``.
///
/// Every Markdown node has a corresponding optional visitor and a usable default. Set any node
/// visitor to `nil` to flatten that node through the configured text visitor.
public struct MarkdownMarkupVisitors {

    // MARK: - Document Visitor - Public

    /// The root-document visitor, or `nil` to join its block children as plain content.
    public var document: (any IDocumentVisitor)?

    // MARK: - Block Visitors - Public

    /// The block-quote visitor, or `nil` to flatten block quotes.
    public var blockQuote: (any IBlockQuoteVisitor)?
    /// The code-block visitor, or `nil` to emit raw code as text.
    public var codeBlock: (any ICodeBlockVisitor)?
    /// The custom-block visitor, or `nil` to flatten custom blocks.
    public var customBlock: (any ICustomBlockVisitor)?
    /// The heading visitor, or `nil` to flatten headings.
    public var heading: (any IHeadingVisitor)?
    /// The thematic-break visitor, or `nil` to omit thematic breaks.
    public var thematicBreak: (any IThematicBreakVisitor)?
    /// The HTML-block visitor, or `nil` to emit raw HTML as text.
    public var htmlBlock: (any IHTMLBlockVisitor)?
    /// The list-item visitor, or `nil` to join item children as plain content.
    public var listItem: (any IListItemVisitor)?
    /// The ordered-list visitor, or `nil` to flatten ordered lists.
    public var orderedList: (any IOrderedListVisitor)?
    /// The unordered-list visitor, or `nil` to flatten unordered lists.
    public var unorderedList: (any IUnorderedListVisitor)?
    /// The paragraph visitor, or `nil` to flatten paragraphs.
    public var paragraph: (any IParagraphVisitor)?
    /// The block-directive visitor, or `nil` to flatten block directives.
    public var blockDirective: (any IBlockDirectiveVisitor)?

    // MARK: - Inline Visitors - Public

    /// The inline-code visitor, or `nil` to emit code as ordinary text.
    public var inlineCode: (any IInlineCodeVisitor)?
    /// The custom-inline visitor, or `nil` to emit its text unchanged.
    public var customInline: (any ICustomInlineVisitor)?
    /// The emphasis visitor, or `nil` to flatten emphasis.
    public var emphasis: (any IEmphasisVisitor)?
    /// The image visitor, or `nil` to emit alternative text.
    public var image: (any IImageVisitor)?
    /// The inline-HTML visitor, or `nil` to emit raw HTML as text.
    public var inlineHTML: (any IInlineHTMLVisitor)?
    /// The explicit line-break visitor, or `nil` to omit explicit breaks.
    public var lineBreak: (any ILineBreakVisitor)?
    /// The link visitor, or `nil` to flatten links and disable unmarked-link detection.
    public var link: (any ILinkVisitor)?
    /// The soft-break visitor, or `nil` to omit soft breaks.
    public var softBreak: (any ISoftBreakVisitor)?
    /// The strong visitor, or `nil` to flatten strong content.
    public var strong: (any IStrongVisitor)?
    /// The required base visitor used for source text and generated characters.
    public var text: any ITextVisitor
    /// The strikethrough visitor, or `nil` to flatten strikethrough content.
    public var strikethrough: (any IStrikethroughVisitor)?
    /// The symbol-link visitor, or `nil` to emit its destination as text.
    public var symbolLink: (any ISymbolLinkVisitor)?
    /// The inline-attributes visitor, or `nil` to flatten attributed inline nodes.
    public var inlineAttributes: (any IInlineAttributesVisitor)?

    // MARK: - Table Visitors - Public

    /// The table visitor, or `nil` to flatten tables.
    public var table: (any ITableVisitor)?
    /// The table-header visitor, or `nil` to flatten headers.
    public var tableHead: (any ITableHeadVisitor)?
    /// The table-body visitor, or `nil` to flatten bodies.
    public var tableBody: (any ITableBodyVisitor)?
    /// The table-row visitor, or `nil` to flatten rows.
    public var tableRow: (any ITableRowVisitor)?
    /// The table-cell visitor, or `nil` to flatten cells.
    public var tableCell: (any ITableCellVisitor)?

    // MARK: - Doxygen Visitors - Public

    /// The Doxygen discussion visitor, or `nil` to flatten discussion directives.
    public var doxygenDiscussion: (any IDoxygenDiscussionVisitor)?
    /// The Doxygen note visitor, or `nil` to flatten note directives.
    public var doxygenNote: (any IDoxygenNoteVisitor)?
    /// The Doxygen abstract visitor, or `nil` to flatten abstract directives.
    public var doxygenAbstract: (any IDoxygenAbstractVisitor)?
    /// The Doxygen parameter visitor, or `nil` to flatten parameter directives.
    public var doxygenParameter: (any IDoxygenParameterVisitor)?
    /// The Doxygen returns visitor, or `nil` to flatten returns directives.
    public var doxygenReturns: (any IDoxygenReturnsVisitor)?

    // MARK: - Custom Visitors - Public

    /// Post-processing visitors run in declaration order after built-in rendering.
    public var custom: [any ICustomVisitor]

    // MARK: - Initialization - Public

    /// Creates a complete visitor set.
    ///
    /// Every optional parameter has a usable default. Pass `nil` for a node whose
    /// element-specific rendering should be removed while retaining readable content.
    public init(
        text: any ITextVisitor = MarkdownDefaultTextVisitor(),
        link: (any ILinkVisitor)? = MarkdownDefaultLinkVisitor(),
        strong: (any IStrongVisitor)? = MarkdownDefaultStrongVisitor(),
        emphasis: (any IEmphasisVisitor)? = MarkdownDefaultEmphasisVisitor(),
        heading: (any IHeadingVisitor)? = MarkdownDefaultHeadingVisitor(),
        strikethrough: (any IStrikethroughVisitor)? = MarkdownDefaultStrikethroughVisitor(),
        document: (any IDocumentVisitor)? = MarkdownDefaultDocumentVisitor(),
        blockQuote: (any IBlockQuoteVisitor)? = MarkdownDefaultBlockQuoteVisitor(),
        codeBlock: (any ICodeBlockVisitor)? = MarkdownDefaultCodeBlockVisitor(),
        customBlock: (any ICustomBlockVisitor)? = MarkdownDefaultCustomBlockVisitor(),
        thematicBreak: (any IThematicBreakVisitor)? = MarkdownDefaultThematicBreakVisitor(),
        htmlBlock: (any IHTMLBlockVisitor)? = MarkdownDefaultHTMLBlockVisitor(),
        listItem: (any IListItemVisitor)? = MarkdownDefaultListItemVisitor(),
        orderedList: (any IOrderedListVisitor)? = MarkdownDefaultOrderedListVisitor(),
        unorderedList: (any IUnorderedListVisitor)? = MarkdownDefaultUnorderedListVisitor(),
        paragraph: (any IParagraphVisitor)? = MarkdownDefaultParagraphVisitor(),
        blockDirective: (any IBlockDirectiveVisitor)? = MarkdownDefaultBlockDirectiveVisitor(),
        inlineCode: (any IInlineCodeVisitor)? = MarkdownDefaultInlineCodeVisitor(),
        customInline: (any ICustomInlineVisitor)? = MarkdownDefaultCustomInlineVisitor(),
        image: (any IImageVisitor)? = MarkdownDefaultImageVisitor(),
        inlineHTML: (any IInlineHTMLVisitor)? = MarkdownDefaultInlineHTMLVisitor(),
        lineBreak: (any ILineBreakVisitor)? = MarkdownDefaultLineBreakVisitor(),
        softBreak: (any ISoftBreakVisitor)? = MarkdownDefaultSoftBreakVisitor(),
        symbolLink: (any ISymbolLinkVisitor)? = MarkdownDefaultSymbolLinkVisitor(),
        inlineAttributes: (any IInlineAttributesVisitor)? = MarkdownDefaultInlineAttributesVisitor(),
        table: (any ITableVisitor)? = MarkdownDefaultTableVisitor(),
        tableHead: (any ITableHeadVisitor)? = MarkdownDefaultTableHeadVisitor(),
        tableBody: (any ITableBodyVisitor)? = MarkdownDefaultTableBodyVisitor(),
        tableRow: (any ITableRowVisitor)? = MarkdownDefaultTableRowVisitor(),
        tableCell: (any ITableCellVisitor)? = MarkdownDefaultTableCellVisitor(),
        doxygenDiscussion: (any IDoxygenDiscussionVisitor)? = MarkdownDefaultDoxygenDiscussionVisitor(),
        doxygenNote: (any IDoxygenNoteVisitor)? = MarkdownDefaultDoxygenNoteVisitor(),
        doxygenAbstract: (any IDoxygenAbstractVisitor)? = MarkdownDefaultDoxygenAbstractVisitor(),
        doxygenParameter: (any IDoxygenParameterVisitor)? = MarkdownDefaultDoxygenParameterVisitor(),
        doxygenReturns: (any IDoxygenReturnsVisitor)? = MarkdownDefaultDoxygenReturnsVisitor(),
        custom: [any ICustomVisitor] = []
    ) {
        self.text = text
        self.link = link
        self.strong = strong
        self.emphasis = emphasis
        self.heading = heading
        self.strikethrough = strikethrough
        self.document = document
        self.blockQuote = blockQuote
        self.codeBlock = codeBlock
        self.customBlock = customBlock
        self.thematicBreak = thematicBreak
        self.htmlBlock = htmlBlock
        self.listItem = listItem
        self.orderedList = orderedList
        self.unorderedList = unorderedList
        self.paragraph = paragraph
        self.blockDirective = blockDirective
        self.inlineCode = inlineCode
        self.customInline = customInline
        self.image = image
        self.inlineHTML = inlineHTML
        self.lineBreak = lineBreak
        self.softBreak = softBreak
        self.symbolLink = symbolLink
        self.inlineAttributes = inlineAttributes
        self.table = table
        self.tableHead = tableHead
        self.tableBody = tableBody
        self.tableRow = tableRow
        self.tableCell = tableCell
        self.doxygenDiscussion = doxygenDiscussion
        self.doxygenNote = doxygenNote
        self.doxygenAbstract = doxygenAbstract
        self.doxygenParameter = doxygenParameter
        self.doxygenReturns = doxygenReturns
        self.custom = custom
    }

}
