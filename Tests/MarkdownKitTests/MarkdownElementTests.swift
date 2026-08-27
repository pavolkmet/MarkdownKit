import Foundation
import Markdown
import XCTest

@testable import MarkdownKit

final class MarkdownElementTests: XCTestCase {

    // MARK: - Tests - Defaults

    func testDefaultsResolveMatchingVisitorForEverySupportedMarkdownType() {
        let visitors = MarkdownElement.visitors(from: MarkdownElement.defaults, appearance: .default)

        assertDefaultVisitors(visitors)
    }

    func testDefaultOverridePathResolvesMatchingVisitorForEverySupportedMarkdownType() {
        let visitors = MarkdownElement.visitors(
            defaultElementsOverriddenBy: [],
            appearance: .default
        )

        assertDefaultVisitors(visitors)
    }

    func testDefaultOverridePathMatchesExplicitDefaultElements() {
        var appearance = MarkdownAppearance.default
        appearance.text = MarkdownTextAppearance(
            container: attributeContainer(PriorityTestAttribute.self, "text")
        )
        let overrides: [MarkdownElement] = [
            .link(.disabled),
            .strong(.appearance(MarkdownTextAppearance(
                container: attributeContainer(PriorityTestAttribute.self, "strong")
            ))),
            .unorderedList(.appearance(MarkdownListAppearance(indentation: 4))),
            .custom(AppendingVisitor(value: "-custom")),
        ]
        let source = "**Strong** [Link](https://example.com)\n\n- Parent\n  - Child"
        let expected = MarkdownRenderer(
            elements: MarkdownElement.defaults + overrides,
            appearance: appearance
        )
        .attributedString(from: source)
        let result = MarkdownRenderer(
            defaultElementsOverriddenBy: overrides,
            appearance: appearance
        )
        .attributedString(from: source)

        XCTAssertEqual(result, expected)
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

    private func assertDefaultVisitors(_ visitors: MarkdownMarkupVisitors, file: StaticString = #filePath, line: UInt = #line) {
        assertVisitor(visitors.document, is: MarkdownDefaultDocumentVisitor.self, file: file, line: line)
        assertVisitor(visitors.blockQuote, is: MarkdownDefaultBlockQuoteVisitor.self, file: file, line: line)
        assertVisitor(visitors.codeBlock, is: MarkdownDefaultCodeBlockVisitor.self, file: file, line: line)
        assertVisitor(visitors.customBlock, is: MarkdownDefaultCustomBlockVisitor.self, file: file, line: line)
        assertVisitor(visitors.heading, is: MarkdownDefaultHeadingVisitor.self, file: file, line: line)
        assertVisitor(visitors.thematicBreak, is: MarkdownDefaultThematicBreakVisitor.self, file: file, line: line)
        assertVisitor(visitors.htmlBlock, is: MarkdownDefaultHTMLBlockVisitor.self, file: file, line: line)
        assertVisitor(visitors.listItem, is: MarkdownDefaultListItemVisitor.self, file: file, line: line)
        assertVisitor(visitors.orderedList, is: MarkdownDefaultOrderedListVisitor.self, file: file, line: line)
        assertVisitor(visitors.unorderedList, is: MarkdownDefaultUnorderedListVisitor.self, file: file, line: line)
        assertVisitor(visitors.paragraph, is: MarkdownDefaultParagraphVisitor.self, file: file, line: line)
        assertVisitor(visitors.blockDirective, is: MarkdownDefaultBlockDirectiveVisitor.self, file: file, line: line)
        assertVisitor(visitors.inlineCode, is: MarkdownDefaultInlineCodeVisitor.self, file: file, line: line)
        assertVisitor(visitors.customInline, is: MarkdownDefaultCustomInlineVisitor.self, file: file, line: line)
        assertVisitor(visitors.emphasis, is: MarkdownDefaultEmphasisVisitor.self, file: file, line: line)
        assertVisitor(visitors.image, is: MarkdownDefaultImageVisitor.self, file: file, line: line)
        assertVisitor(visitors.inlineHTML, is: MarkdownDefaultInlineHTMLVisitor.self, file: file, line: line)
        assertVisitor(visitors.lineBreak, is: MarkdownDefaultLineBreakVisitor.self, file: file, line: line)
        assertVisitor(visitors.link, is: MarkdownDefaultLinkVisitor.self, file: file, line: line)
        assertVisitor(visitors.softBreak, is: MarkdownDefaultSoftBreakVisitor.self, file: file, line: line)
        assertVisitor(visitors.strong, is: MarkdownDefaultStrongVisitor.self, file: file, line: line)
        assertVisitor(visitors.text, is: MarkdownDefaultTextVisitor.self, file: file, line: line)
        assertVisitor(visitors.strikethrough, is: MarkdownDefaultStrikethroughVisitor.self, file: file, line: line)
        assertVisitor(visitors.symbolLink, is: MarkdownDefaultSymbolLinkVisitor.self, file: file, line: line)
        assertVisitor(visitors.inlineAttributes, is: MarkdownDefaultInlineAttributesVisitor.self, file: file, line: line)
        assertVisitor(visitors.table, is: MarkdownDefaultTableVisitor.self, file: file, line: line)
        assertVisitor(visitors.tableHead, is: MarkdownDefaultTableHeadVisitor.self, file: file, line: line)
        assertVisitor(visitors.tableBody, is: MarkdownDefaultTableBodyVisitor.self, file: file, line: line)
        assertVisitor(visitors.tableRow, is: MarkdownDefaultTableRowVisitor.self, file: file, line: line)
        assertVisitor(visitors.tableCell, is: MarkdownDefaultTableCellVisitor.self, file: file, line: line)
        assertVisitor(visitors.doxygenDiscussion, is: MarkdownDefaultDoxygenDiscussionVisitor.self, file: file, line: line)
        assertVisitor(visitors.doxygenNote, is: MarkdownDefaultDoxygenNoteVisitor.self, file: file, line: line)
        assertVisitor(visitors.doxygenAbstract, is: MarkdownDefaultDoxygenAbstractVisitor.self, file: file, line: line)
        assertVisitor(visitors.doxygenParameter, is: MarkdownDefaultDoxygenParameterVisitor.self, file: file, line: line)
        assertVisitor(visitors.doxygenReturns, is: MarkdownDefaultDoxygenReturnsVisitor.self, file: file, line: line)
        XCTAssertTrue(visitors.custom.isEmpty, file: file, line: line)
    }

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
