import Foundation
import Markdown
import XCTest

@testable import MarkdownKit

final class MarkdownElementTests: XCTestCase {

    // MARK: - Tests - Defaults

    func testDefaultsResolveMatchingVisitorForEverySupportedMarkdownType() {
        let visitors = MarkdownElement.visitors(from: MarkdownElement.defaults, appearance: .default)

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

    // MARK: - Tests - Precedence

    func testDefaultElementUsesSharedAppearance() {
        var appearance = MarkdownAppearance.default
        appearance.link = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "shared")
        )
        let result = MarkdownRenderer(
            elements: [.document(.default), .paragraph(.default), .text(.default), .link(.default)],
            appearance: appearance
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "shared")
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
    }

    func testElementAppearanceOverridesSharedAppearance() {
        var appearance = MarkdownAppearance.default
        appearance.link = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "shared")
        )
        let override = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "element")
        )
        let result = MarkdownRenderer(
            elements: [.link(.appearance(override))],
            appearance: appearance
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "element")
    }

    func testVisitorOwnsElementBehavior() {
        let result = MarkdownRenderer(
            elements: [
                .link(.appearance(MarkdownTextAppearance(
                    container: attributeContainer(PriorityTestAttribute.self, "appearance")
                ))),
                .link(.visitor(PriorityLinkVisitor(value: "visitor"))),
            ]
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "visitor")
    }

    func testLastConfigurationForAnElementWins() {
        let first = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "first")
        )
        let second = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "second")
        )
        let result = MarkdownRenderer(
            elements: [.link(.appearance(first)), .link(.disabled), .link(.appearance(second))]
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "second")
        XCTAssertEqual(links(in: result).count, 1)
    }

    func testDisabledElementFlattensToReadableText() {
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.link(.disabled)]
        )
        .attributedString(from: "[Link](https://example.com) and https://swift.org")

        XCTAssertEqual(renderedText(result), "Link and https://swift.org")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testDisabledTextKeepsContentWithoutSharedTextAttributes() {
        var appearance = MarkdownAppearance.default
        appearance.text = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "shared")
        )
        let result = MarkdownRenderer(
            elements: [.text(.disabled)],
            appearance: appearance
        )
        .attributedString(from: "Readable")

        XCTAssertEqual(renderedText(result), "Readable")
        XCTAssertNil(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result))
    }

    func testEnvironmentStyleOverrideCanBeAppliedAfterInitializerElements() {
        let initializerElements = MarkdownElement.defaults + [.link(.default)]
        let environmentElements: [MarkdownElement] = [.link(.disabled)]
        let result = MarkdownRenderer(
            elements: initializerElements + environmentElements
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(renderedText(result), "Link")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    // MARK: - Tests - Rendering

    func testTextAndDocumentRenderingProduceTheSameResult() {
        let source = "# Title\n\n**Strong** [Link](https://example.com)"
        let renderer = MarkdownRenderer()

        XCTAssertEqual(
            renderer.attributedString(from: source),
            renderer.attributedString(from: Document(parsing: source))
        )
    }

    func testCustomVisitorsRunInDeclarationOrder() {
        let result = MarkdownRenderer(
            elements: [
                .text(.default),
                .custom(AppendingVisitor(value: "-first")),
                .custom(AppendingVisitor(value: "-second")),
            ]
        )
        .attributedString(from: "value")

        XCTAssertEqual(renderedText(result), "value-first-second")
    }

    func testListAppearanceOverrideOwnsMarkersAndIndentation() {
        let appearance = MarkdownListAppearance(
            marker: attributeContainer(PriorityTestAttribute.self, "marker"),
            indentation: 4
        )
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.unorderedList(.appearance(appearance))]
        )
        .attributedString(from: "- Parent\n  - Child")

        XCTAssertEqual(renderedText(result), "• Parent\n    • Child")
        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "marker")
        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 9, in: result), "marker")
    }

    // MARK: - Helper Methods - Private

    private func assertVisitor<Visitor>(_ visitor: Any?, is type: Visitor.Type, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(visitor is Visitor, "Expected \(Visitor.self), got \(String(describing: visitor))", file: file, line: line)
    }
}

private struct PriorityLinkVisitor: ILinkVisitor {
    let value: String

    func attributes(for text: String, destination: URL, source: MarkdownLinkSource) -> AttributeContainer? {
        attributeContainer(PriorityTestAttribute.self, value)
    }
}

private struct AppendingVisitor: ICustomVisitor {
    let value: String

    func visit(attributedString: inout AttributedString) {
        attributedString.append(AttributedString(value))
    }
}
