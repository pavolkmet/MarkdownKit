import Foundation

extension MarkdownElement {

    // MARK: - Helper Methods - Internal

    static func visitors(from elements: [MarkdownElement], appearance: MarkdownAppearance) -> MarkdownMarkupVisitors {
        var visitors = MarkdownMarkupVisitors(
            text: MarkdownDefaultTextVisitor(container: appearance.text.container),
            link: nil,
            strong: nil,
            emphasis: nil,
            heading: nil,
            strikethrough: nil,
            document: nil,
            blockQuote: nil,
            codeBlock: nil,
            customBlock: nil,
            thematicBreak: nil,
            htmlBlock: nil,
            listItem: MarkdownDefaultListItemVisitor(),
            orderedList: nil,
            unorderedList: nil,
            paragraph: nil,
            blockDirective: nil,
            inlineCode: nil,
            customInline: nil,
            image: nil,
            inlineHTML: nil,
            lineBreak: nil,
            softBreak: nil,
            symbolLink: nil,
            inlineAttributes: nil,
            table: nil,
            tableHead: nil,
            tableBody: nil,
            tableRow: nil,
            tableCell: nil,
            doxygenDiscussion: nil,
            doxygenNote: nil,
            doxygenAbstract: nil,
            doxygenParameter: nil,
            doxygenReturns: nil
        )

        apply(elements, to: &visitors, appearance: appearance)
        return visitors
    }

    static func visitors(defaultElementsOverriddenBy overrides: [MarkdownElement], appearance: MarkdownAppearance) -> MarkdownMarkupVisitors {
        var visitors = defaultVisitors(appearance: appearance)
        apply(overrides, to: &visitors, appearance: appearance)
        return visitors
    }

    // MARK: - Helper Methods - Private

    private static func defaultVisitors(appearance: MarkdownAppearance) -> MarkdownMarkupVisitors {
        MarkdownMarkupVisitors(
            text: MarkdownDefaultTextVisitor(container: appearance.text.container),
            link: MarkdownDefaultLinkVisitor(container: appearance.link.container),
            strong: MarkdownDefaultStrongVisitor(container: appearance.strong.container),
            emphasis: MarkdownDefaultEmphasisVisitor(container: appearance.emphasis.container),
            heading: MarkdownDefaultHeadingVisitor(appearance: appearance.heading),
            strikethrough: MarkdownDefaultStrikethroughVisitor(container: appearance.strikethrough.container),
            orderedList: MarkdownDefaultOrderedListVisitor(appearance: appearance.orderedList),
            unorderedList: MarkdownDefaultUnorderedListVisitor(appearance: appearance.unorderedList)
        )
    }

    private static func apply(_ elements: [MarkdownElement], to visitors: inout MarkdownMarkupVisitors, appearance: MarkdownAppearance) {
        for element in elements {
            switch element {
            case .document(let configuration):
                switch configuration {
                case .disabled:
                    visitors.document = nil
                case .default:
                    visitors.document = MarkdownDefaultDocumentVisitor()
                case .visitor(let visitor):
                    visitors.document = visitor
                }
            case .blockQuote(let configuration):
                switch configuration {
                case .disabled:
                    visitors.blockQuote = nil
                case .default:
                    visitors.blockQuote = MarkdownDefaultBlockQuoteVisitor()
                case .visitor(let visitor):
                    visitors.blockQuote = visitor
                }
            case .codeBlock(let configuration):
                switch configuration {
                case .disabled:
                    visitors.codeBlock = nil
                case .default:
                    visitors.codeBlock = MarkdownDefaultCodeBlockVisitor()
                case .visitor(let visitor):
                    visitors.codeBlock = visitor
                }
            case .customBlock(let configuration):
                switch configuration {
                case .disabled:
                    visitors.customBlock = nil
                case .default:
                    visitors.customBlock = MarkdownDefaultCustomBlockVisitor()
                case .visitor(let visitor):
                    visitors.customBlock = visitor
                }
            case .heading(let configuration):
                switch configuration {
                case .disabled:
                    visitors.heading = nil
                case .default:
                    visitors.heading = MarkdownDefaultHeadingVisitor(appearance: appearance.heading)
                case .appearance(let value):
                    visitors.heading = MarkdownDefaultHeadingVisitor(appearance: value)
                case .visitor(let visitor):
                    visitors.heading = visitor
                }
            case .thematicBreak(let configuration):
                switch configuration {
                case .disabled:
                    visitors.thematicBreak = nil
                case .default:
                    visitors.thematicBreak = MarkdownDefaultThematicBreakVisitor()
                case .visitor(let visitor):
                    visitors.thematicBreak = visitor
                }
            case .htmlBlock(let configuration):
                switch configuration {
                case .disabled:
                    visitors.htmlBlock = nil
                case .default:
                    visitors.htmlBlock = MarkdownDefaultHTMLBlockVisitor()
                case .visitor(let visitor):
                    visitors.htmlBlock = visitor
                }
            case .listItem(let configuration):
                switch configuration {
                case .disabled:
                    visitors.listItem = nil
                case .default:
                    visitors.listItem = MarkdownDefaultListItemVisitor()
                case .visitor(let visitor):
                    visitors.listItem = visitor
                }
            case .orderedList(let configuration):
                switch configuration {
                case .disabled:
                    visitors.orderedList = nil
                case .default:
                    visitors.orderedList = MarkdownDefaultOrderedListVisitor(appearance: appearance.orderedList)
                case .appearance(let value):
                    visitors.orderedList = MarkdownDefaultOrderedListVisitor(appearance: value)
                case .visitor(let visitor):
                    visitors.orderedList = visitor
                }
            case .unorderedList(let configuration):
                switch configuration {
                case .disabled:
                    visitors.unorderedList = nil
                case .default:
                    visitors.unorderedList = MarkdownDefaultUnorderedListVisitor(appearance: appearance.unorderedList)
                case .appearance(let value):
                    visitors.unorderedList = MarkdownDefaultUnorderedListVisitor(appearance: value)
                case .visitor(let visitor):
                    visitors.unorderedList = visitor
                }
            case .paragraph(let configuration):
                switch configuration {
                case .disabled:
                    visitors.paragraph = nil
                case .default:
                    visitors.paragraph = MarkdownDefaultParagraphVisitor()
                case .visitor(let visitor):
                    visitors.paragraph = visitor
                }
            case .blockDirective(let configuration):
                switch configuration {
                case .disabled:
                    visitors.blockDirective = nil
                case .default:
                    visitors.blockDirective = MarkdownDefaultBlockDirectiveVisitor()
                case .visitor(let visitor):
                    visitors.blockDirective = visitor
                }
            case .inlineCode(let configuration):
                switch configuration {
                case .disabled:
                    visitors.inlineCode = nil
                case .default:
                    visitors.inlineCode = MarkdownDefaultInlineCodeVisitor()
                case .visitor(let visitor):
                    visitors.inlineCode = visitor
                }
            case .customInline(let configuration):
                switch configuration {
                case .disabled:
                    visitors.customInline = nil
                case .default:
                    visitors.customInline = MarkdownDefaultCustomInlineVisitor()
                case .visitor(let visitor):
                    visitors.customInline = visitor
                }
            case .emphasis(let configuration):
                switch configuration {
                case .disabled:
                    visitors.emphasis = nil
                case .default:
                    visitors.emphasis = MarkdownDefaultEmphasisVisitor(container: appearance.emphasis.container)
                case .appearance(let value):
                    visitors.emphasis = MarkdownDefaultEmphasisVisitor(container: value.container)
                case .visitor(let visitor):
                    visitors.emphasis = visitor
                }
            case .image(let configuration):
                switch configuration {
                case .disabled:
                    visitors.image = nil
                case .default:
                    visitors.image = MarkdownDefaultImageVisitor()
                case .visitor(let visitor):
                    visitors.image = visitor
                }
            case .inlineHTML(let configuration):
                switch configuration {
                case .disabled:
                    visitors.inlineHTML = nil
                case .default:
                    visitors.inlineHTML = MarkdownDefaultInlineHTMLVisitor()
                case .visitor(let visitor):
                    visitors.inlineHTML = visitor
                }
            case .lineBreak(let configuration):
                switch configuration {
                case .disabled:
                    visitors.lineBreak = nil
                case .default:
                    visitors.lineBreak = MarkdownDefaultLineBreakVisitor()
                case .visitor(let visitor):
                    visitors.lineBreak = visitor
                }
            case .link(let configuration):
                switch configuration {
                case .disabled:
                    visitors.link = nil
                case .default:
                    visitors.link = MarkdownDefaultLinkVisitor(container: appearance.link.container)
                case .appearance(let value):
                    visitors.link = MarkdownDefaultLinkVisitor(container: value.container)
                case .visitor(let visitor):
                    visitors.link = visitor
                }
            case .softBreak(let configuration):
                switch configuration {
                case .disabled:
                    visitors.softBreak = nil
                case .default:
                    visitors.softBreak = MarkdownDefaultSoftBreakVisitor()
                case .visitor(let visitor):
                    visitors.softBreak = visitor
                }
            case .strong(let configuration):
                switch configuration {
                case .disabled:
                    visitors.strong = nil
                case .default:
                    visitors.strong = MarkdownDefaultStrongVisitor(container: appearance.strong.container)
                case .appearance(let value):
                    visitors.strong = MarkdownDefaultStrongVisitor(container: value.container)
                case .visitor(let visitor):
                    visitors.strong = visitor
                }
            case .text(let configuration):
                switch configuration {
                case .disabled:
                    visitors.text = MarkdownDefaultTextVisitor(container: AttributeContainer())
                case .default:
                    visitors.text = MarkdownDefaultTextVisitor(container: appearance.text.container)
                case .appearance(let value):
                    visitors.text = MarkdownDefaultTextVisitor(container: value.container)
                case .visitor(let visitor):
                    visitors.text = visitor
                }
            case .strikethrough(let configuration):
                switch configuration {
                case .disabled:
                    visitors.strikethrough = nil
                case .default:
                    visitors.strikethrough = MarkdownDefaultStrikethroughVisitor(container: appearance.strikethrough.container)
                case .appearance(let value):
                    visitors.strikethrough = MarkdownDefaultStrikethroughVisitor(container: value.container)
                case .visitor(let visitor):
                    visitors.strikethrough = visitor
                }
            case .symbolLink(let configuration):
                switch configuration {
                case .disabled:
                    visitors.symbolLink = nil
                case .default:
                    visitors.symbolLink = MarkdownDefaultSymbolLinkVisitor()
                case .visitor(let visitor):
                    visitors.symbolLink = visitor
                }
            case .inlineAttributes(let configuration):
                switch configuration {
                case .disabled:
                    visitors.inlineAttributes = nil
                case .default:
                    visitors.inlineAttributes = MarkdownDefaultInlineAttributesVisitor()
                case .visitor(let visitor):
                    visitors.inlineAttributes = visitor
                }
            case .table(let configuration):
                switch configuration {
                case .disabled:
                    visitors.table = nil
                case .default:
                    visitors.table = MarkdownDefaultTableVisitor()
                case .visitor(let visitor):
                    visitors.table = visitor
                }
            case .tableHead(let configuration):
                switch configuration {
                case .disabled:
                    visitors.tableHead = nil
                case .default:
                    visitors.tableHead = MarkdownDefaultTableHeadVisitor()
                case .visitor(let visitor):
                    visitors.tableHead = visitor
                }
            case .tableBody(let configuration):
                switch configuration {
                case .disabled:
                    visitors.tableBody = nil
                case .default:
                    visitors.tableBody = MarkdownDefaultTableBodyVisitor()
                case .visitor(let visitor):
                    visitors.tableBody = visitor
                }
            case .tableRow(let configuration):
                switch configuration {
                case .disabled:
                    visitors.tableRow = nil
                case .default:
                    visitors.tableRow = MarkdownDefaultTableRowVisitor()
                case .visitor(let visitor):
                    visitors.tableRow = visitor
                }
            case .tableCell(let configuration):
                switch configuration {
                case .disabled:
                    visitors.tableCell = nil
                case .default:
                    visitors.tableCell = MarkdownDefaultTableCellVisitor()
                case .visitor(let visitor):
                    visitors.tableCell = visitor
                }
            case .doxygenDiscussion(let configuration):
                switch configuration {
                case .disabled:
                    visitors.doxygenDiscussion = nil
                case .default:
                    visitors.doxygenDiscussion = MarkdownDefaultDoxygenDiscussionVisitor()
                case .visitor(let visitor):
                    visitors.doxygenDiscussion = visitor
                }
            case .doxygenNote(let configuration):
                switch configuration {
                case .disabled:
                    visitors.doxygenNote = nil
                case .default:
                    visitors.doxygenNote = MarkdownDefaultDoxygenNoteVisitor()
                case .visitor(let visitor):
                    visitors.doxygenNote = visitor
                }
            case .doxygenAbstract(let configuration):
                switch configuration {
                case .disabled:
                    visitors.doxygenAbstract = nil
                case .default:
                    visitors.doxygenAbstract = MarkdownDefaultDoxygenAbstractVisitor()
                case .visitor(let visitor):
                    visitors.doxygenAbstract = visitor
                }
            case .doxygenParameter(let configuration):
                switch configuration {
                case .disabled:
                    visitors.doxygenParameter = nil
                case .default:
                    visitors.doxygenParameter = MarkdownDefaultDoxygenParameterVisitor()
                case .visitor(let visitor):
                    visitors.doxygenParameter = visitor
                }
            case .doxygenReturns(let configuration):
                switch configuration {
                case .disabled:
                    visitors.doxygenReturns = nil
                case .default:
                    visitors.doxygenReturns = MarkdownDefaultDoxygenReturnsVisitor()
                case .visitor(let visitor):
                    visitors.doxygenReturns = visitor
                }
            case .custom(let visitor):
                visitors.custom.append(visitor)
            }
        }
    }
}
