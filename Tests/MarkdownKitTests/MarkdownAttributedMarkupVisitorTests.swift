import Foundation
import Markdown
import XCTest

@testable import MarkdownKit

final class MarkdownAttributedMarkupVisitorTests: XCTestCase {
    func testGranularVisitorsReplaceOnlyLinkBehaviorAndKeepOtherDefaults() {
        let visitors = MarkdownMarkupVisitors(link: SourceAwareLinkVisitor())
        let result = MarkdownRenderer(visitors: visitors).attributedString(
            from: "**[Markdown](https://example.com)** and www.swift.org"
        )
        let text = renderedText(result)
        let markdownOffset = text.firstOffset(of: "Markdown")
        let unmarkedOffset = text.firstOffset(of: "www.swift.org")

        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: markdownOffset, in: result),
            "markdown"
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: unmarkedOffset, in: result),
            "unmarked"
        )
        XCTAssertTrue(
            inlineIntent(atCharacterOffset: markdownOffset, in: result)?
                .contains(.stronglyEmphasized) == true
        )
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["https://example.com", "https://www.swift.org"]
        )
    }

    func testGranularVisitorCanDisableOnlyStrongBehavior() {
        let visitors = MarkdownMarkupVisitors(
            strong: MarkdownDefaultStrongVisitor(container: nil)
        )
        let result = MarkdownRenderer(visitors: visitors).attributedString(
            from: "**strong** *emphasis* https://example.com"
        )
        let text = renderedText(result)

        XCTAssertFalse(
            inlineIntent(atCharacterOffset: text.firstOffset(of: "strong"), in: result)?
                .contains(.stronglyEmphasized) == true
        )
        XCTAssertTrue(
            inlineIntent(atCharacterOffset: text.firstOffset(of: "emphasis"), in: result)?
                .contains(.emphasized) == true
        )
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
    }

    func testLinkVisitorCanOptOutOfUnmarkedDetectionWithoutDisablingMarkdownLinks() {
        let visitors = MarkdownMarkupVisitors(link: MarkdownOnlyLinkVisitor())
        let result = MarkdownRenderer(visitors: visitors).attributedString(
            from: "[Markdown](https://example.com) and https://swift.org"
        )

        XCTAssertEqual(links(in: result).map(\.text), ["Markdown"])
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
    }

    func testGranularHeadingAndStrikethroughVisitorsCanBeCustomized() {
        let visitors = MarkdownMarkupVisitors(
            heading: MarkdownDefaultHeadingVisitor(
                container: attributeContainer(PriorityTestAttribute.self, "heading")
            ),
            strikethrough: MarkdownDefaultStrikethroughVisitor(
                container: attributeContainer(PriorityTestAttribute.self, "strikethrough")
            )
        )
        let result = MarkdownRenderer(visitors: visitors)
            .attributedString(from: "# Heading\n\n~~Removed~~")
        let text = renderedText(result)

        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Heading"), in: result),
            "heading"
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Removed"), in: result),
            "strikethrough"
        )
    }

    func testGranularTextVisitorReceivesEachRenderedTextValue() {
        let visitors = MarkdownMarkupVisitors(text: EchoingTextVisitor())
        let result = MarkdownRenderer(visitors: visitors)
            .attributedString(from: "Alpha **Beta**")
        let text = renderedText(result)

        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Alpha"), in: result),
            "Alpha "
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Beta"), in: result),
            "Beta"
        )
    }

    func testMutableGranularVisitorStateIsCopiedForEveryParse() {
        let visitors = MarkdownMarkupVisitors(link: CountingLinkVisitor())
        let renderer = MarkdownRenderer(visitors: visitors)

        let first = renderer.attributedString(
            from: "[One](https://one.example) [Two](https://two.example)"
        )
        let second = renderer.attributedString(from: "[Again](https://again.example)")

        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: first),
            "link-1"
        )
        XCTAssertEqual(
            attribute(
                PriorityTestAttribute.self,
                atCharacterOffset: renderedText(first).firstOffset(of: "Two"),
                in: first
            ),
            "link-2"
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: second),
            "link-1"
        )
    }

    func testStrongAppearanceAndSemanticIntent() {
        let result = renderer().attributedString(from: "plain **strong**")
        let offset = renderedText(result).firstOffset(of: "strong")

        XCTAssertEqual(attribute(StrongTestAttribute.self, atCharacterOffset: offset, in: result), true)
        XCTAssertTrue(inlineIntent(atCharacterOffset: offset, in: result)?.contains(.stronglyEmphasized) == true)
    }

    func testEmphasisAppearanceAndSemanticIntent() {
        let result = renderer().attributedString(from: "plain *emphasis*")
        let offset = renderedText(result).firstOffset(of: "emphasis")

        XCTAssertEqual(attribute(EmphasisTestAttribute.self, atCharacterOffset: offset, in: result), true)
        XCTAssertTrue(inlineIntent(atCharacterOffset: offset, in: result)?.contains(.emphasized) == true)
    }

    func testNestedStrongAndEmphasisRetainBothAppearances() {
        let result = renderer().attributedString(from: "***both***")

        XCTAssertEqual(attribute(StrongTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(EmphasisTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertTrue(inlineIntent(atCharacterOffset: 0, in: result)?.contains(.stronglyEmphasized) == true)
        XCTAssertTrue(inlineIntent(atCharacterOffset: 0, in: result)?.contains(.emphasized) == true)
    }

    func testLinksInsideStrongAndEmphasisRetainAllAppearances() {
        let result = renderer().attributedString(
            from: "***[Example](https://example.com)***"
        )

        XCTAssertEqual(attribute(StrongTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(EmphasisTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(LinkTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
    }

    func testLinkAppearanceHasHighestPrecedence() {
        let base = attributeContainer(PriorityTestAttribute.self, "base")
        let strong = mergedAttributeContainers(
            attributeContainer(PriorityTestAttribute.self, "strong"),
            attributeContainer(StrongTestAttribute.self, true)
        )
        let link = mergedAttributeContainers(
            attributeContainer(PriorityTestAttribute.self, "link"),
            attributeContainer(LinkTestAttribute.self, true)
        )
        let appearance = MarkdownAppearance(
            text: base,
            link: link,
            strong: strong
        )
        let result = MarkdownRenderer(appearance: appearance)
            .attributedString(from: "**[Example](https://example.com)**")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "link")
        XCTAssertEqual(attribute(StrongTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(LinkTestAttribute.self, atCharacterOffset: 0, in: result), true)
    }

    func testCompleteAppearancePrecedenceAcrossListsAndNestedInlineElements() {
        let appearance = MarkdownAppearance(
            text: attributeContainer(PriorityTestAttribute.self, "base"),
            link: mergedAttributeContainers(
                attributeContainer(PriorityTestAttribute.self, "link"),
                attributeContainer(LinkTestAttribute.self, true)
            ),
            strong: mergedAttributeContainers(
                attributeContainer(PriorityTestAttribute.self, "strong"),
                attributeContainer(StrongTestAttribute.self, true)
            ),
            emphasis: mergedAttributeContainers(
                attributeContainer(PriorityTestAttribute.self, "emphasis"),
                attributeContainer(EmphasisTestAttribute.self, true)
            ),
            unorderedList: MarkdownListAppearance(
                marker: attributeContainer(PriorityTestAttribute.self, "marker"),
                item: mergedAttributeContainers(
                    attributeContainer(PriorityTestAttribute.self, "item"),
                    attributeContainer(ItemTestAttribute.self, true)
                )
            )
        )
        let result = MarkdownRenderer(appearance: appearance)
            .attributedString(from: "- Plain ***Both*** ***[Link](https://example.com)***")
        let text = renderedText(result)

        XCTAssertEqual(text, "• Plain Both Link")
        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "marker")
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Plain"), in: result),
            "item"
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Both"), in: result),
            "emphasis"
        )
        XCTAssertEqual(
            attribute(PriorityTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Link"), in: result),
            "link"
        )
        XCTAssertEqual(
            attribute(StrongTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Link"), in: result),
            true
        )
        XCTAssertEqual(
            attribute(EmphasisTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Link"), in: result),
            true
        )
        XCTAssertEqual(
            attribute(ItemTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Link"), in: result),
            true
        )
    }

    func testEmptyContainersEnableEverySemanticElement() {
        let enabled = AttributeContainer()
        let list = MarkdownListAppearance(marker: enabled, item: enabled)
        let appearance = MarkdownAppearance(
            text: enabled,
            link: enabled,
            strong: enabled,
            emphasis: enabled,
            unorderedList: list,
            orderedList: list
        )
        let result = MarkdownRenderer(appearance: appearance)
            .attributedString(from: "- ***[Enabled](https://example.com)***")
        let offset = renderedText(result).firstOffset(of: "Enabled")

        XCTAssertEqual(renderedText(result), "• Enabled")
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
        XCTAssertTrue(inlineIntent(atCharacterOffset: offset, in: result)?.contains(.stronglyEmphasized) == true)
        XCTAssertTrue(inlineIntent(atCharacterOffset: offset, in: result)?.contains(.emphasized) == true)
    }

    func testStrongElementDisabled() {
        let appearance = MarkdownAppearance(
            text: AttributeContainer(),
            emphasis: AttributeContainer()
        )
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.strong(.disabled)],
            appearance: appearance
        )
            .attributedString(from: "**strong** and *emphasis*")

        XCTAssertFalse(inlineIntent(atCharacterOffset: 0, in: result)?.contains(.stronglyEmphasized) == true)
        let emphasisOffset = renderedText(result).firstOffset(of: "emphasis")
        XCTAssertTrue(inlineIntent(atCharacterOffset: emphasisOffset, in: result)?.contains(.emphasized) == true)
    }

    func testEmphasisElementDisabled() {
        let appearance = MarkdownAppearance(
            text: AttributeContainer(),
            strong: AttributeContainer()
        )
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.emphasis(.disabled)],
            appearance: appearance
        )
            .attributedString(from: "**strong** and *emphasis*")

        XCTAssertTrue(inlineIntent(atCharacterOffset: 0, in: result)?.contains(.stronglyEmphasized) == true)
        let emphasisOffset = renderedText(result).firstOffset(of: "emphasis")
        XCTAssertFalse(inlineIntent(atCharacterOffset: emphasisOffset, in: result)?.contains(.emphasized) == true)
    }

    func testUnorderedList() {
        let result = renderer().attributedString(from: "- First\n- Second")

        XCTAssertEqual(renderedText(result), "• First\n• Second")
        XCTAssertEqual(attribute(MarkerTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(ItemTestAttribute.self, atCharacterOffset: 2, in: result), true)
    }

    func testOrderedListUsesSourceStartIndex() {
        let result = renderer().attributedString(from: "3. Third\n4. Fourth")

        XCTAssertEqual(renderedText(result), "3. Third\n4. Fourth")
        XCTAssertEqual(attribute(MarkerTestAttribute.self, atCharacterOffset: 0, in: result), true)
        XCTAssertEqual(attribute(ItemTestAttribute.self, atCharacterOffset: 3, in: result), true)
    }

    func testNestedListsUseLiteralIndentation() {
        let source = """
        - First
          - Nested
        - Second
        """
        let result = renderer(indentation: 2).attributedString(from: source)

        XCTAssertEqual(renderedText(result), "• First\n  • Nested\n• Second")
    }

    func testMixedOrderedAndUnorderedListsUseStructuralDepth() {
        let source = "2. Outer\n   - Inner\n       1. Deep\n3. End"
        let result = renderer(indentation: 2).attributedString(from: source)

        XCTAssertEqual(renderedText(result), "2. Outer\n  • Inner\n    1. Deep\n3. End")
    }

    func testDisabledOuterListStillPreservesNestedEnabledListDepth() {
        let enabled = MarkdownListAppearance(indentation: 3)
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [
                .orderedList(.disabled),
                .unorderedList(.appearance(enabled)),
            ]
        )
            .attributedString(from: "1. Outer\n   - Inner")

        XCTAssertEqual(renderedText(result), "Outer\n   • Inner")
    }

    func testNegativeListIndentationIsClampedToZero() {
        let result = renderer(indentation: -20).attributedString(
            from: "- Outer\n  - Inner"
        )

        XCTAssertEqual(renderedText(result), "• Outer\n• Inner")
    }

    func testLooseListItemParagraphsHavePredictableLineBreaks() {
        let source = """
        - First paragraph

          Second paragraph
        - Next
        """
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), "• First paragraph\nSecond paragraph\n• Next")
    }

    func testTaskListsRenderAsOrdinaryUnorderedLists() {
        let result = renderer().attributedString(from: "- [x] Complete\n- [ ] Pending")

        XCTAssertEqual(renderedText(result), "• Complete\n• Pending")
    }

    func testInlineFormattingInsideListItems() {
        let result = renderer().attributedString(
            from: "- **Strong** and *emphasized* [link](https://example.com)"
        )
        let text = renderedText(result)

        XCTAssertEqual(text, "• Strong and emphasized link")
        XCTAssertEqual(
            attribute(StrongTestAttribute.self, atCharacterOffset: text.firstOffset(of: "Strong"), in: result),
            true
        )
        XCTAssertEqual(
            attribute(EmphasisTestAttribute.self, atCharacterOffset: text.firstOffset(of: "emphasized"), in: result),
            true
        )
        XCTAssertEqual(links(in: result).map(\.text), ["link"])
    }

    func testListElementDisabledKeepsReadableContent() {
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [
                .unorderedList(.disabled),
                .orderedList(.disabled),
            ]
        )
            .attributedString(from: "- First\n- Second\n\n1. One\n2. Two")

        XCTAssertEqual(renderedText(result), "First\nSecond\nOne\nTwo")
    }

    func testAdditiveHashtagVisitorAddsLinksWithoutOverwritingMarkdownLinks() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(TestHashtagVisitor())],
            appearance: enabledAppearance()
        )
        let result = renderer.attributedString(
            from: "Visit #Swift and [#Existing](https://example.com/original)"
        )

        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            [
                "https://hornet.com/search/Swift",
                "https://example.com/original",
            ]
        )
        XCTAssertEqual(
            attribute(
                HashtagTestAttribute.self,
                atCharacterOffset: renderedText(result).firstOffset(of: "#Swift"),
                in: result
            ),
            true
        )
        XCTAssertNil(
            attribute(
                HashtagTestAttribute.self,
                atCharacterOffset: renderedText(result).firstOffset(of: "#Existing"),
                in: result
            )
        )
    }

    func testHashtagVisitorSupportsUnicodeAndKeepsExistingLinkRangesIntact() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(TestHashtagVisitor())],
            appearance: enabledAppearance()
        )
        let result = renderer.attributedString(
            from: "#café #cafe\u{301} #日本語 [#linked-日本語](spaces://existing)"
        )

        XCTAssertEqual(
            links(in: result).map(\.text),
            ["#café", "#cafe\u{301}", "#日本語", "#linked-日本語"]
        )
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            [
                "https://hornet.com/search/caf%C3%A9",
                "https://hornet.com/search/cafe%CC%81",
                "https://hornet.com/search/%E6%97%A5%E6%9C%AC%E8%AA%9E",
                "spaces://existing",
            ]
        )
    }

    func testCustomVisitorsReceiveFinalBuiltInAppearanceAndCanOverrideIt() {
        let appearance = MarkdownAppearance(
            text: attributeContainer(PriorityTestAttribute.self, "base"),
            link: attributeContainer(PriorityTestAttribute.self, "link")
        )
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(PriorityOverrideVisitor())],
            appearance: appearance
        )
        let result = renderer.attributedString(from: "[value](https://example.com)")

        XCTAssertEqual(attribute(PriorityTestAttribute.self, atCharacterOffset: 0, in: result), "custom")
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://example.com"])
    }

    func testCustomVisitorCanRemoveBuiltInLinkSemantics() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(RemovingLinksVisitor())],
            appearance: enabledAppearance()
        )
        let result = renderer.attributedString(
            from: "[Markdown](https://example.com) and https://swift.org"
        )

        XCTAssertEqual(renderedText(result), "Markdown and https://swift.org")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testMultipleCustomVisitorsRunInOrderAndRetainMutations() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [
                .custom(AppendingVisitor(value: "1")),
                .custom(AppendingVisitor(value: "2")),
            ],
            appearance: enabledAppearance()
        )

        XCTAssertEqual(renderedText(renderer.attributedString(from: "value")), "value12")
    }

    func testReadmeLanguageVisitorExample() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(LanguageVisitor())],
            appearance: enabledAppearance()
        )
        let result = renderer.attributedString(from: "Example")

        XCTAssertEqual(result.languageIdentifier, "en")
    }

    func testCompleteVisitorReplacementIsCopiedForEveryParse() {
        let renderer = MarkdownRenderer(visitor: ReplacementVisitor())

        XCTAssertEqual(renderedText(renderer.attributedString(from: "first")), "replacement-1")
        XCTAssertEqual(renderedText(renderer.attributedString(from: "second")), "replacement-1")
    }

    func testDirectDefaultVisitorReuseDoesNotRetainListOrExplicitLinkDepth() {
        var visitor = MarkdownAttributedMarkupVisitor(
            visitors: MarkdownElement.visitors(
                from: MarkdownElement.defaults,
                appearance: enabledAppearance()
            )
        )

        _ = visitor.visit(Document(parsing: "- [first](https://example.com)"))
        let result = visitor.visit(Document(parsing: "www.swift.org"))

        XCTAssertEqual(renderedText(result), "www.swift.org")
        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://www.swift.org"])
    }

    private func renderer(indentation: Int = 2) -> MarkdownRenderer {
        MarkdownRenderer(appearance: enabledAppearance(indentation: indentation))
    }

    private func inlineIntent(
        atCharacterOffset offset: Int,
        in attributedString: AttributedString
    ) -> InlinePresentationIntent? {
        let index = attributedString.characters.index(
            attributedString.startIndex,
            offsetBy: offset
        )
        return attributedString.runs
            .first(where: { $0.range.contains(index) })?
            .inlinePresentationIntent
    }
}

private struct TestHashtagVisitor: ICustomVisitor {
    private static let expression = try! NSRegularExpression(
        pattern: #"(?<![\p{L}\p{M}\p{N}_])#[\p{L}\p{M}\p{N}_]+"#
    )

    func visit(attributedString: inout AttributedString) {
        let text = renderedText(attributedString)
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = Self.expression.matches(in: text, range: fullRange).reversed()

        for match in matches {
            guard let stringRange = Range(match.range, in: text) else {
                continue
            }
            let lowerOffset = text.distance(from: text.startIndex, to: stringRange.lowerBound)
            let upperOffset = text.distance(from: text.startIndex, to: stringRange.upperBound)
            let lowerBound = attributedString.characters.index(
                attributedString.startIndex,
                offsetBy: lowerOffset
            )
            let upperBound = attributedString.characters.index(
                attributedString.startIndex,
                offsetBy: upperOffset
            )
            let attributedRange = lowerBound..<upperBound

            guard !attributedString[attributedRange].runs.contains(where: { $0.link != nil }) else {
                continue
            }

            let hashtag = String(text[stringRange].dropFirst())
            guard
                let encodedHashtag = hashtag.addingPercentEncoding(
                    withAllowedCharacters: .urlPathAllowed
                ),
                let url = URL(string: "https://hornet.com/search/\(encodedHashtag)")
            else {
                continue
            }

            attributedString[attributedRange].link = url
            attributedString[attributedRange][HashtagTestAttribute.self] = true
        }
    }
}

private struct SourceAwareLinkVisitor: ILinkVisitor {
    func attributes(
        for text: String,
        destination: URL,
        source: MarkdownLinkSource
    ) -> AttributeContainer? {
        let value: String
        switch source {
        case .markdown:
            value = "markdown"
        case .unmarked:
            value = "unmarked"
        }
        return attributeContainer(PriorityTestAttribute.self, value)
    }
}

private struct EchoingTextVisitor: ITextVisitor {
    func attributes(for text: String) -> AttributeContainer {
        attributeContainer(PriorityTestAttribute.self, text)
    }
}

private struct MarkdownOnlyLinkVisitor: ILinkVisitor {
    let shouldDetectUnmarkedLinks = false

    func attributes(
        for text: String,
        destination: URL,
        source: MarkdownLinkSource
    ) -> AttributeContainer? {
        AttributeContainer()
    }
}

private struct CountingLinkVisitor: ILinkVisitor {
    private var count = 0

    mutating func attributes(
        for text: String,
        destination: URL,
        source: MarkdownLinkSource
    ) -> AttributeContainer? {
        count += 1
        return attributeContainer(PriorityTestAttribute.self, "link-\(count)")
    }
}

private struct AppendingVisitor: ICustomVisitor {
    let value: String

    func visit(attributedString: inout AttributedString) {
        attributedString.append(AttributedString(value))
    }
}

private struct LanguageVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {
        attributedString.languageIdentifier = "en"
    }
}

private struct PriorityOverrideVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {
        attributedString[PriorityTestAttribute.self] = "custom"
    }
}

private struct RemovingLinksVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {
        attributedString.link = nil
    }
}

private struct ReplacementVisitor: MarkupVisitor {
    private var visitCount = 0

    mutating func defaultVisit(_ markup: Markup) -> AttributedString {
        AttributedString()
    }

    mutating func visitDocument(_ document: Document) -> AttributedString {
        visitCount += 1
        return AttributedString("replacement-\(visitCount)")
    }
}

private extension String {
    func firstOffset(of substring: String) -> Int {
        guard let range = range(of: substring) else {
            XCTFail("Missing substring: \(substring)")
            return 0
        }
        return distance(from: startIndex, to: range.lowerBound)
    }
}
