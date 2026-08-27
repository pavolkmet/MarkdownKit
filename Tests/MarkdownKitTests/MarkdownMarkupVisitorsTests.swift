import Foundation
import Markdown
import XCTest

@testable import MarkdownKit

final class MarkdownMarkupVisitorsTests: XCTestCase {

    // MARK: - Tests - Defaults

    func testInitializerAssignsMatchingDefaultVisitorForEveryMarkdownType() {
        let visitors = MarkdownMarkupVisitors()

        assertVisitor(visitors.document, is: MarkdownDefaultDocumentVisitor.self)
        assertVisitor(visitors.blockQuote, is: MarkdownDefaultBlockQuoteVisitor.self)
        assertVisitor(visitors.codeBlock, is: MarkdownDefaultCodeBlockVisitor.self)
        assertVisitor(visitors.customBlock, is: MarkdownDefaultCustomBlockVisitor.self)
        assertVisitor(visitors.heading, is: MarkdownDefaultHeadingVisitor.self)
        assertVisitor(visitors.thematicBreak, is: MarkdownDefaultThematicBreakVisitor.self)
        assertVisitor(visitors.htmlBlock, is: MarkdownDefaultHTMLBlockVisitor.self)
        assertVisitor(visitors.listItem, is: MarkdownDefaultListItemVisitor.self)
        assertVisitor(visitors.orderedList, is: MarkdownDefaultOrderedListVisitor.self)
        assertVisitor(visitors.unorderedList, is: MarkdownDefaultUnorderedListVisitor.self)
        assertVisitor(visitors.paragraph, is: MarkdownDefaultParagraphVisitor.self)
        assertVisitor(visitors.blockDirective, is: MarkdownDefaultBlockDirectiveVisitor.self)
        assertVisitor(visitors.inlineCode, is: MarkdownDefaultInlineCodeVisitor.self)
        assertVisitor(visitors.customInline, is: MarkdownDefaultCustomInlineVisitor.self)
        assertVisitor(visitors.emphasis, is: MarkdownDefaultEmphasisVisitor.self)
        assertVisitor(visitors.image, is: MarkdownDefaultImageVisitor.self)
        assertVisitor(visitors.inlineHTML, is: MarkdownDefaultInlineHTMLVisitor.self)
        assertVisitor(visitors.lineBreak, is: MarkdownDefaultLineBreakVisitor.self)
        assertVisitor(visitors.link, is: MarkdownDefaultLinkVisitor.self)
        assertVisitor(visitors.softBreak, is: MarkdownDefaultSoftBreakVisitor.self)
        assertVisitor(visitors.strong, is: MarkdownDefaultStrongVisitor.self)
        assertVisitor(visitors.text, is: MarkdownDefaultTextVisitor.self)
        assertVisitor(visitors.strikethrough, is: MarkdownDefaultStrikethroughVisitor.self)
        assertVisitor(visitors.symbolLink, is: MarkdownDefaultSymbolLinkVisitor.self)
        assertVisitor(visitors.inlineAttributes, is: MarkdownDefaultInlineAttributesVisitor.self)
        assertVisitor(visitors.table, is: MarkdownDefaultTableVisitor.self)
        assertVisitor(visitors.tableHead, is: MarkdownDefaultTableHeadVisitor.self)
        assertVisitor(visitors.tableBody, is: MarkdownDefaultTableBodyVisitor.self)
        assertVisitor(visitors.tableRow, is: MarkdownDefaultTableRowVisitor.self)
        assertVisitor(visitors.tableCell, is: MarkdownDefaultTableCellVisitor.self)
        assertVisitor(visitors.doxygenDiscussion, is: MarkdownDefaultDoxygenDiscussionVisitor.self)
        assertVisitor(visitors.doxygenNote, is: MarkdownDefaultDoxygenNoteVisitor.self)
        assertVisitor(visitors.doxygenAbstract, is: MarkdownDefaultDoxygenAbstractVisitor.self)
        assertVisitor(visitors.doxygenParameter, is: MarkdownDefaultDoxygenParameterVisitor.self)
        assertVisitor(visitors.doxygenReturns, is: MarkdownDefaultDoxygenReturnsVisitor.self)
        XCTAssertTrue(visitors.custom.isEmpty)
    }

    // MARK: - Tests - Fallbacks

    func testEveryOptionalVisitorCanBeRemovedThroughInitializer() {
        let visitors = MarkdownMarkupVisitors(
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
            listItem: nil,
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

        XCTAssertNil(visitors.document)
        XCTAssertNil(visitors.blockQuote)
        XCTAssertNil(visitors.codeBlock)
        XCTAssertNil(visitors.customBlock)
        XCTAssertNil(visitors.heading)
        XCTAssertNil(visitors.thematicBreak)
        XCTAssertNil(visitors.htmlBlock)
        XCTAssertNil(visitors.listItem)
        XCTAssertNil(visitors.orderedList)
        XCTAssertNil(visitors.unorderedList)
        XCTAssertNil(visitors.paragraph)
        XCTAssertNil(visitors.blockDirective)
        XCTAssertNil(visitors.inlineCode)
        XCTAssertNil(visitors.customInline)
        XCTAssertNil(visitors.emphasis)
        XCTAssertNil(visitors.image)
        XCTAssertNil(visitors.inlineHTML)
        XCTAssertNil(visitors.lineBreak)
        XCTAssertNil(visitors.link)
        XCTAssertNil(visitors.softBreak)
        XCTAssertNil(visitors.strong)
        XCTAssertNil(visitors.strikethrough)
        XCTAssertNil(visitors.symbolLink)
        XCTAssertNil(visitors.inlineAttributes)
        XCTAssertNil(visitors.table)
        XCTAssertNil(visitors.tableHead)
        XCTAssertNil(visitors.tableBody)
        XCTAssertNil(visitors.tableRow)
        XCTAssertNil(visitors.tableCell)
        XCTAssertNil(visitors.doxygenDiscussion)
        XCTAssertNil(visitors.doxygenNote)
        XCTAssertNil(visitors.doxygenAbstract)
        XCTAssertNil(visitors.doxygenParameter)
        XCTAssertNil(visitors.doxygenReturns)
        assertVisitor(visitors.text, is: MarkdownDefaultTextVisitor.self)
    }

    func testMissingVisitorsFlattenParsedMarkdownIntoReadableText() {
        let visitors = visitorsWithoutOptionalVisitors()
        let renderer = MarkdownRenderer(visitors: visitors)
        let source = """
        # Heading

        > Quote

        - **Strong** and *emphasis* [Link](https://example.com)

        `code` ![Alt](https://example.com/image)

        | A | B |
        | - | - |
        | C | D |
        """
        let result = renderer.attributedString(from: source)

        XCTAssertEqual(
            renderedText(result),
            "Heading\nQuote\nStrong and emphasis Link\ncode Alt\nA | B\nC | D"
        )
        XCTAssertTrue(links(in: result).isEmpty)
        XCTAssertNil(result.inlinePresentationIntent)
    }

    func testMissingRareNodeVisitorsStillUseTheirReadableContent() {
        var visitor = MarkdownAttributedMarkupVisitor(visitors: visitorsWithoutOptionalVisitors())
        let paragraph = Paragraph(Text("content"))

        XCTAssertEqual(renderedText(visitor.visit(CustomBlock([paragraph]))), "content")
        XCTAssertEqual(
            renderedText(visitor.visit(BlockDirective(name: "Example", children: paragraph))),
            "content"
        )
        XCTAssertEqual(renderedText(visitor.visit(CustomInline("inline"))), "inline")
        XCTAssertEqual(
            renderedText(visitor.visit(InlineAttributes(attributes: "role: test", Text("inline")))),
            "inline"
        )
        XCTAssertEqual(renderedText(visitor.visit(SymbolLink(destination: "Module.Type"))), "Module.Type")
        XCTAssertEqual(renderedText(visitor.visit(DoxygenDiscussion(children: paragraph))), "content")
        XCTAssertEqual(renderedText(visitor.visit(DoxygenNote(children: paragraph))), "content")
        XCTAssertEqual(renderedText(visitor.visit(DoxygenAbstract(children: paragraph))), "content")
        XCTAssertEqual(
            renderedText(visitor.visit(DoxygenParameter(name: "value", children: paragraph))),
            "content"
        )
        XCTAssertEqual(renderedText(visitor.visit(DoxygenReturns(children: paragraph))), "content")
        XCTAssertEqual(renderedText(visitor.visit(ThematicBreak())), "")
    }

    // MARK: - Helper Methods - Private

    private func visitorsWithoutOptionalVisitors() -> MarkdownMarkupVisitors {
        var visitors = MarkdownMarkupVisitors()
        visitors.document = nil
        visitors.blockQuote = nil
        visitors.codeBlock = nil
        visitors.customBlock = nil
        visitors.heading = nil
        visitors.thematicBreak = nil
        visitors.htmlBlock = nil
        visitors.listItem = nil
        visitors.orderedList = nil
        visitors.unorderedList = nil
        visitors.paragraph = nil
        visitors.blockDirective = nil
        visitors.inlineCode = nil
        visitors.customInline = nil
        visitors.emphasis = nil
        visitors.image = nil
        visitors.inlineHTML = nil
        visitors.lineBreak = nil
        visitors.link = nil
        visitors.softBreak = nil
        visitors.strong = nil
        visitors.strikethrough = nil
        visitors.symbolLink = nil
        visitors.inlineAttributes = nil
        visitors.table = nil
        visitors.tableHead = nil
        visitors.tableBody = nil
        visitors.tableRow = nil
        visitors.tableCell = nil
        visitors.doxygenDiscussion = nil
        visitors.doxygenNote = nil
        visitors.doxygenAbstract = nil
        visitors.doxygenParameter = nil
        visitors.doxygenReturns = nil
        return visitors
    }

    private func assertVisitor<Visitor>(_ visitor: Any?, is type: Visitor.Type, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(visitor is Visitor, "Expected \(Visitor.self), got \(String(describing: visitor))", file: file, line: line)
    }
}
