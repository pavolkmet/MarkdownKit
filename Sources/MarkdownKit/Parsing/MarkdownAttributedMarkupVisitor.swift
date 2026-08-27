import Foundation
import Markdown

/// Routes every swift-markdown node to its corresponding focused visitor.
public struct MarkdownAttributedMarkupVisitor: MarkupVisitor {

    // MARK: - Properties - Public

    /// The focused visitors used for each Markdown node.
    public var visitors: MarkdownMarkupVisitors

    // MARK: - Initialization - Public

    /// Creates a markup visitor from individually replaceable element visitors.
    public init(visitors: MarkdownMarkupVisitors = MarkdownMarkupVisitors()) {
        self.visitors = visitors
    }

    // MARK: - MarkupVisitor

    public mutating func defaultVisit(_ markup: Markup) -> AttributedString {
        markup.children.map { visit($0) }.concatenated
    }

    public mutating func visitDocument(_ document: Document) -> AttributedString {
        let children = document.children.map { visit($0) }
        var result: AttributedString

        if var documentVisitor = visitors.document {
            result = documentVisitor.visit(
                children: children,
                visitor: &visitors.text
            )
            visitors.document = documentVisitor
        } else {
            result = children.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        if var strongVisitor = visitors.strong {
            strongVisitor.finalize(attributedString: &result)
            visitors.strong = strongVisitor
        }
        if var emphasisVisitor = visitors.emphasis {
            emphasisVisitor.finalize(attributedString: &result)
            visitors.emphasis = emphasisVisitor
        }
        if var linkVisitor = visitors.link {
            linkVisitor.finalize(attributedString: &result)
            visitors.link = linkVisitor
        }
        for customVisitor in visitors.custom {
            customVisitor.visit(attributedString: &result)
        }

        return result
    }

    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> AttributedString {
        let children = blockQuote.children.map { visit($0) }
        guard var visitor = visitors.blockQuote else {
            return children.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(children: children, visitor: &visitors.text)
        visitors.blockQuote = visitor
        return result
    }

    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> AttributedString {
        guard var visitor = visitors.codeBlock else {
            return visitors.text.visit(text: codeBlock.code)
        }

        let result = visitor.visit(code: codeBlock.code, visitor: &visitors.text)
        visitors.codeBlock = visitor
        return result
    }

    public mutating func visitCustomBlock(_ customBlock: CustomBlock) -> AttributedString {
        let children = customBlock.children.map { visit($0) }
        guard var visitor = visitors.customBlock else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.customBlock = visitor
        return result
    }

    public mutating func visitHeading(_ heading: Heading) -> AttributedString {
        let children = heading.children.map { visit($0) }
        guard var visitor = visitors.heading else {
            return children.concatenated
        }

        let result = visitor.visit(
            children: children,
            level: heading.level
        )
        visitors.heading = visitor
        return result
    }

    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> AttributedString {
        guard var visitor = visitors.thematicBreak else {
            return AttributedString()
        }

        let result = visitor.visit()
        visitors.thematicBreak = visitor
        return result
    }

    public mutating func visitHTMLBlock(_ html: HTMLBlock) -> AttributedString {
        guard var visitor = visitors.htmlBlock else {
            return visitors.text.visit(text: html.rawHTML)
        }

        let result = visitor.visit(rawHTML: html.rawHTML, visitor: &visitors.text)
        visitors.htmlBlock = visitor
        return result
    }

    public mutating func visitListItem(_ listItem: ListItem) -> AttributedString {
        let children = listItem.children.map { child in
            MarkdownListItemChild(
                attributedString: visit(child),
                isList: child is OrderedList || child is UnorderedList
            )
        }
        let appearance: MarkdownListAppearance?
        if listItem.parent is OrderedList {
            appearance = visitors.orderedList?.appearance
        } else {
            appearance = visitors.unorderedList?.appearance
        }

        guard var visitor = visitors.listItem else {
            return children.map(\.attributedString).joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(
            children: children,
            appearance: appearance,
            visitor: &visitors.text
        )
        visitors.listItem = visitor
        return result
    }

    public mutating func visitOrderedList(_ orderedList: OrderedList) -> AttributedString {
        let items = orderedList.children.map { visit($0) }
        guard var visitor = visitors.orderedList else {
            return items.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(
            items: items,
            startIndex: orderedList.startIndex,
            depth: orderedList.listDepth,
            visitor: &visitors.text
        )
        visitors.orderedList = visitor
        return result
    }

    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> AttributedString {
        let items = unorderedList.children.map { visit($0) }
        guard var visitor = visitors.unorderedList else {
            return items.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(
            items: items,
            depth: unorderedList.listDepth,
            visitor: &visitors.text
        )
        visitors.unorderedList = visitor
        return result
    }

    public mutating func visitParagraph(_ paragraph: Paragraph) -> AttributedString {
        let children = paragraph.children.map { visit($0) }
        guard var visitor = visitors.paragraph else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.paragraph = visitor
        return result
    }

    public mutating func visitBlockDirective(_ blockDirective: BlockDirective) -> AttributedString {
        let children = blockDirective.children.map { visit($0) }
        guard var visitor = visitors.blockDirective else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.blockDirective = visitor
        return result
    }

    public mutating func visitInlineCode(_ inlineCode: InlineCode) -> AttributedString {
        guard var visitor = visitors.inlineCode else {
            return visitors.text.visit(text: inlineCode.code)
        }

        let result = visitor.visit(code: inlineCode.code, visitor: &visitors.text)
        visitors.inlineCode = visitor
        return result
    }

    public mutating func visitCustomInline(_ customInline: CustomInline) -> AttributedString {
        guard var visitor = visitors.customInline else {
            return visitors.text.visit(text: customInline.text)
        }

        let result = visitor.visit(text: customInline.text, visitor: &visitors.text)
        visitors.customInline = visitor
        return result
    }

    public mutating func visitEmphasis(_ emphasis: Emphasis) -> AttributedString {
        let children = emphasis.children.map { visit($0) }
        guard var visitor = visitors.emphasis else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.emphasis = visitor
        return result
    }

    public mutating func visitImage(_ image: Image) -> AttributedString {
        let altText = image.plainText
        guard var visitor = visitors.image else {
            return visitors.text.visit(text: altText)
        }

        let result = visitor.visit(altText: altText, visitor: &visitors.text)
        visitors.image = visitor
        return result
    }

    public mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> AttributedString {
        guard var visitor = visitors.inlineHTML else {
            return visitors.text.visit(text: inlineHTML.rawHTML)
        }

        let result = visitor.visit(rawHTML: inlineHTML.rawHTML, visitor: &visitors.text)
        visitors.inlineHTML = visitor
        return result
    }

    public mutating func visitLineBreak(_ lineBreak: LineBreak) -> AttributedString {
        guard var visitor = visitors.lineBreak else {
            return visitors.text.visit(text: "\n")
        }

        let result = visitor.visit(visitor: &visitors.text)
        visitors.lineBreak = visitor
        return result
    }

    public mutating func visitLink(_ link: Link) -> AttributedString {
        let children = link.children.map { visit($0) }
        guard var visitor = visitors.link else {
            return children.concatenated
        }

        let result = visitor.visit(
            children: children,
            destination: link.destination
        )
        visitors.link = visitor
        return result
    }

    public mutating func visitSoftBreak(_ softBreak: SoftBreak) -> AttributedString {
        guard var visitor = visitors.softBreak else {
            return visitors.text.visit(text: "\n")
        }

        let result = visitor.visit(visitor: &visitors.text)
        visitors.softBreak = visitor
        return result
    }

    public mutating func visitStrong(_ strong: Strong) -> AttributedString {
        let children = strong.children.map { visit($0) }
        guard var visitor = visitors.strong else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.strong = visitor
        return result
    }

    public mutating func visitText(_ text: Text) -> AttributedString {
        guard var linkVisitor = visitors.link else {
            return visitors.text.visit(text: text.string)
        }

        let result = linkVisitor.visit(
            text: text.string,
            isInsideLink: text.isInsideLink,
            visitor: &visitors.text
        )
        visitors.link = linkVisitor
        return result
    }

    public mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> AttributedString {
        let children = strikethrough.children.map { visit($0) }
        guard var visitor = visitors.strikethrough else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.strikethrough = visitor
        return result
    }

    public mutating func visitTable(_ table: Table) -> AttributedString {
        let children = table.children.map { visit($0) }
        guard var visitor = visitors.table else {
            return children.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(children: children, visitor: &visitors.text)
        visitors.table = visitor
        return result
    }

    public mutating func visitTableHead(_ tableHead: Table.Head) -> AttributedString {
        let children = tableHead.children.map { visit($0) }
        guard var visitor = visitors.tableHead else {
            return children.joined(
                separator: visitors.text.visit(text: " | ")
            )
        }

        let result = visitor.visit(children: children, visitor: &visitors.text)
        visitors.tableHead = visitor
        return result
    }

    public mutating func visitTableBody(_ tableBody: Table.Body) -> AttributedString {
        let children = tableBody.children.map { visit($0) }
        guard var visitor = visitors.tableBody else {
            return children.joined(
                separator: visitors.text.visit(text: "\n")
            )
        }

        let result = visitor.visit(children: children, visitor: &visitors.text)
        visitors.tableBody = visitor
        return result
    }

    public mutating func visitTableRow(_ tableRow: Table.Row) -> AttributedString {
        let children = tableRow.children.map { visit($0) }
        guard var visitor = visitors.tableRow else {
            return children.joined(
                separator: visitors.text.visit(text: " | ")
            )
        }

        let result = visitor.visit(children: children, visitor: &visitors.text)
        visitors.tableRow = visitor
        return result
    }

    public mutating func visitTableCell(_ tableCell: Table.Cell) -> AttributedString {
        let children = tableCell.children.map { visit($0) }
        guard var visitor = visitors.tableCell else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.tableCell = visitor
        return result
    }

    public mutating func visitSymbolLink(_ symbolLink: SymbolLink) -> AttributedString {
        guard var visitor = visitors.symbolLink else {
            return visitors.text.visit(text: symbolLink.destination ?? "")
        }

        let result = visitor.visit(
            destination: symbolLink.destination,
            visitor: &visitors.text
        )
        visitors.symbolLink = visitor
        return result
    }

    public mutating func visitInlineAttributes(_ attributes: InlineAttributes) -> AttributedString {
        let children = attributes.children.map { visit($0) }
        guard var visitor = visitors.inlineAttributes else {
            return children.concatenated
        }

        let result = visitor.visit(
            children: children,
            attributes: attributes.attributes
        )
        visitors.inlineAttributes = visitor
        return result
    }

    public mutating func visitDoxygenDiscussion(_ doxygenDiscussion: DoxygenDiscussion) -> AttributedString {
        let children = doxygenDiscussion.children.map { visit($0) }
        guard var visitor = visitors.doxygenDiscussion else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.doxygenDiscussion = visitor
        return result
    }

    public mutating func visitDoxygenNote(_ doxygenNote: DoxygenNote) -> AttributedString {
        let children = doxygenNote.children.map { visit($0) }
        guard var visitor = visitors.doxygenNote else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.doxygenNote = visitor
        return result
    }

    public mutating func visitDoxygenAbstract(_ doxygenAbstract: DoxygenAbstract) -> AttributedString {
        let children = doxygenAbstract.children.map { visit($0) }
        guard var visitor = visitors.doxygenAbstract else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.doxygenAbstract = visitor
        return result
    }

    public mutating func visitDoxygenParameter(_ doxygenParameter: DoxygenParameter) -> AttributedString {
        let children = doxygenParameter.children.map { visit($0) }
        guard var visitor = visitors.doxygenParameter else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.doxygenParameter = visitor
        return result
    }

    public mutating func visitDoxygenReturns(_ doxygenReturns: DoxygenReturns) -> AttributedString {
        let children = doxygenReturns.children.map { visit($0) }
        guard var visitor = visitors.doxygenReturns else {
            return children.concatenated
        }

        let result = visitor.visit(children: children)
        visitors.doxygenReturns = visitor
        return result
    }
}
