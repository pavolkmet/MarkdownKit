import Foundation
import XCTest

#if canImport(UIKit)
import UIKit
#elseif canImport(SwiftUI)
import SwiftUI
#endif

@testable import MarkdownKit

enum BaseTestAttribute: AttributedStringKey {
    typealias Value = String
    static let name = "MarkdownKitTests.base"
}

enum StrongTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.strong"
}

enum EmphasisTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.emphasis"
}

enum LinkTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.link"
}

enum MarkerTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.marker"
}

enum ItemTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.item"
}

enum PriorityTestAttribute: AttributedStringKey {
    typealias Value = String
    static let name = "MarkdownKitTests.priority"
}

enum HashtagTestAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKitTests.hashtag"
}

func attributeContainer<Key: AttributedStringKey>(
    _ key: Key.Type,
    _ value: Key.Value
) -> AttributeContainer where Key.Value: Sendable {
    var attributes = AttributeContainer()
    attributes[key] = value
    return attributes
}

func mergedAttributeContainers(_ containers: AttributeContainer...) -> AttributeContainer {
    var result = AttributeContainer()
    for container in containers {
        result.merge(container)
    }
    return result
}

func enabledAppearance(indentation: Int = 2) -> MarkdownAppearance {
    MarkdownAppearance(
        text: attributeContainer(BaseTestAttribute.self, "base"),
        link: attributeContainer(LinkTestAttribute.self, true),
        strong: attributeContainer(StrongTestAttribute.self, true),
        emphasis: attributeContainer(EmphasisTestAttribute.self, true),
        unorderedList: MarkdownListAppearance(
            marker: attributeContainer(MarkerTestAttribute.self, true),
            item: attributeContainer(ItemTestAttribute.self, true),
            indentation: indentation
        ),
        orderedList: MarkdownListAppearance(
            marker: attributeContainer(MarkerTestAttribute.self, true),
            item: attributeContainer(ItemTestAttribute.self, true),
            indentation: indentation
        )
    )
}

func renderedText(_ attributedString: AttributedString) -> String {
    String(attributedString.characters)
}

func links(in attributedString: AttributedString) -> [(text: String, url: URL)] {
    attributedString.runs.compactMap { run in
        guard let url = run.link else {
            return nil
        }

        return (String(attributedString[run.range].characters), url)
    }
}

func attribute<Key: AttributedStringKey>(
    _ key: Key.Type,
    atCharacterOffset offset: Int,
    in attributedString: AttributedString
) -> Key.Value? where Key.Value: Sendable {
    let index = attributedString.characters.index(
        attributedString.startIndex,
        offsetBy: offset
    )

    return attributedString.runs
        .first(where: { $0.range.contains(index) })?[key]
}

final class MarkdownRendererTests: XCTestCase {
    func testDefaultRendererWorksOutOfTheBox() {
        let result = MarkdownRenderer().attributedString(
            from: "**Strong** *emphasis* [Markdown](https://swift.org) www.example.com\n\n- Item"
        )
        let text = renderedText(result)

        XCTAssertEqual(text, "Strong emphasis Markdown www.example.com\n• Item")
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["https://swift.org", "https://www.example.com"]
        )
        XCTAssertTrue(
            inlineIntent(at: text.firstOffsetForRendererTest(of: "Strong"), in: result)?
                .contains(.stronglyEmphasized) == true
        )
        XCTAssertTrue(
            inlineIntent(at: text.firstOffsetForRendererTest(of: "emphasis"), in: result)?
                .contains(.emphasized) == true
        )
    }

    func testMarkdownLinkTitleAndDestination() {
        let result = renderer().attributedString(
            from: #"[Example](https://example.com/path?q=1#fragment "A title")"#
        )

        XCTAssertEqual(renderedText(result), "Example")
        XCTAssertEqual(links(in: result).map(\.text), ["Example"])
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["https://example.com/path?q=1#fragment"]
        )
    }

    func testUnmarkedLinkDetectionDoesNotOverrideMarkdownLinkDestination() {
        let result = renderer().attributedString(
            from: "[https://display.example](https://destination.example/path)"
        )

        XCTAssertEqual(links(in: result).map(\.text), ["https://display.example"])
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["https://destination.example/path"]
        )
    }

    func testUnmarkedHTTPSLink() {
        assertSingleLink(
            source: "Visit https://example.com today",
            text: "https://example.com",
            destination: "https://example.com"
        )
    }

    func testUnmarkedHTTPLink() {
        assertSingleLink(
            source: "Visit http://example.com today",
            text: "http://example.com",
            destination: "http://example.com"
        )
    }

    func testWWWURLIsNormalizedToHTTPS() {
        assertSingleLink(
            source: "Visit www.example.com today",
            text: "www.example.com",
            destination: "https://www.example.com"
        )
    }

    func testUnmarkedLinksSupportAnyURLScheme() {
        let source = "spaces://username mailto:person@example.com tel:+420123456789 urn:isbn:0451450523 custom+secure://host/path"
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            [
                "spaces://username",
                "mailto:person@example.com",
                "tel:+420123456789",
                "urn:isbn:0451450523",
                "custom+secure://host/path",
            ]
        )
    }

    func testIncompleteUnmarkedLinksRemainOrdinaryText() {
        let source = "https:// spaces:// mailto: urn: www."
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), source)
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testUnmarkedLinkPreservesPathQueryAndFragment() {
        let url = "https://example.com/a/b?q=one&lang=en#details"
        assertSingleLink(source: url, text: url, destination: url)
    }

    func testUnmarkedLinkSurroundedByParentheses() {
        let result = renderer().attributedString(from: "See (https://example.com/path).")

        XCTAssertEqual(renderedText(result), "See (https://example.com/path).")
        XCTAssertEqual(links(in: result).map(\.text), ["https://example.com/path"])
    }

    func testBalancedParenthesesInsideUnmarkedLinkArePreserved() {
        let url = "https://example.com/a_(b)"
        assertSingleLink(source: url, text: url, destination: url)
    }

    func testUnmarkedLinkExcludesTrailingPunctuation() {
        let result = renderer().attributedString(from: "Visit https://example.com/path, then continue!")

        XCTAssertEqual(renderedText(result), "Visit https://example.com/path, then continue!")
        XCTAssertEqual(links(in: result).map(\.text), ["https://example.com/path"])
    }

    func testMultipleUnmarkedLinksAreDetectedInSourceOrder() {
        let source = "First HTTPS://EXAMPLE.COM/a?q=1#top, then www.swift.org/path and http://127.0.0.1:8080/end."
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), source)
        XCTAssertEqual(
            links(in: result).map(\.text),
            [
                "HTTPS://EXAMPLE.COM/a?q=1#top",
                "www.swift.org/path",
                "http://127.0.0.1:8080/end",
            ]
        )
        XCTAssertEqual(
            links(in: result).map { $0.url.scheme?.lowercased() },
            ["https", "https", "http"]
        )
    }

    func testUnmarkedLinkRecognitionUsesUnicodeAwareTokenBoundaries() {
        let source = "_www.example.com éwww.example.com ✅https://swift.org"
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), source)
        XCTAssertEqual(links(in: result).map(\.text), ["https://swift.org"])
    }

    func testUnmarkedLinkTrailingPunctuationMatrix() {
        for punctuation in [".", ",", "!", "?", ";", ":", ")", "]", "}"] {
            let source = "See https://example.com/a?q=1#value\(punctuation)"
            let result = renderer().attributedString(from: source)

            XCTAssertEqual(renderedText(result), source, "Failed for \(punctuation)")
            XCTAssertEqual(
                links(in: result).map(\.text),
                ["https://example.com/a?q=1#value"],
                "Failed for \(punctuation)"
            )
        }
    }

    func testUnmarkedLinkPreservesBalancedDelimitersAndTrimsOnlySurplusClosers() {
        let cases = [
            (
                source: "(https://example.com/a_(b))",
                linkedText: "https://example.com/a_(b)"
            ),
            (
                source: "https://example.com/a_(b)))",
                linkedText: "https://example.com/a_(b)"
            ),
            (
                source: "https://example.com/path}}",
                linkedText: "https://example.com/path"
            ),
        ]

        for testCase in cases {
            let result = renderer().attributedString(from: testCase.source)
            XCTAssertEqual(renderedText(result), testCase.source)
            XCTAssertEqual(links(in: result).map(\.text), [testCase.linkedText])
        }
    }

    func testUnmarkedLinkPreservesPortPercentEncodingQueryAndFragment() {
        let url = "https://example.com:8443/a%20b?q=a%2Fb&empty=#fragment"
        assertSingleLink(source: url, text: url, destination: url)
    }

    func testExplicitLinksSupportRelativeAndApplicationSchemes() {
        let result = renderer().attributedString(
            from: "[Relative](/search/swift) [App](spaces://username) [Email](mailto:test@example.com)"
        )

        XCTAssertEqual(renderedText(result), "Relative App Email")
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["/search/swift", "spaces://username", "mailto:test@example.com"]
        )
    }

    func testCommonMarkAutolinksSupportWebAndEmailDestinations() {
        let result = renderer().attributedString(
            from: "<https://example.com/path> <person@example.com>"
        )

        XCTAssertEqual(renderedText(result), "https://example.com/path person@example.com")
        XCTAssertEqual(
            links(in: result).map(\.url.absoluteString),
            ["https://example.com/path", "mailto:person@example.com"]
        )
    }

    func testUnmarkedIPAddressesAndIPv6Ports() {
        let result = renderer().attributedString(
            from: "http://127.0.0.1:8080/path https://[2001:db8::1]:8443/status"
        )

        XCTAssertEqual(
            links(in: result).map(\.text),
            ["http://127.0.0.1:8080/path", "https://[2001:db8::1]:8443/status"]
        )
    }

    func testUnmarkedLinkExcludesUnicodeSurroundingPunctuation() {
        let cases = [
            ("“https://example.com/path”", "https://example.com/path"),
            ("‘https://example.com/path’", "https://example.com/path"),
            ("«https://example.com/path»", "https://example.com/path"),
            ("https://example.com/path…", "https://example.com/path"),
            ("https://example.com/path。", "https://example.com/path"),
        ]

        for testCase in cases {
            let result = renderer().attributedString(from: testCase.0)
            XCTAssertEqual(renderedText(result), testCase.0)
            XCTAssertEqual(links(in: result).map(\.text), [testCase.1], "Failed for \(testCase.0)")
        }
    }

    func testDefaultAppearanceBridgeMatchesGranularDefaults() {
        let sources = [
            "**Strong** *emphasis* [link](https://example.com) www.swift.org",
            "- First\n  - Nested\n\n3. Third",
            "# Heading\n\n~~ordinary~~ `code` ![alt](https://example.com/image)",
        ]
        let granularParser = MarkdownRenderer()
        let appearanceParser = MarkdownRenderer(appearance: .default)

        for source in sources {
            XCTAssertEqual(
                renderSignature(granularParser.attributedString(from: source)),
                renderSignature(appearanceParser.attributedString(from: source))
            )
        }
    }

    func testEmptyElementSelectionFlattensEveryOptionalElement() {
        let result = MarkdownRenderer(elements: [], appearance: .plainText)
            .attributedString(
                from: "# Heading\n\n**Strong** *emphasis* [link](https://example.com) "
                    + "www.swift.org ~~removed~~\n\n- Item"
            )

        XCTAssertEqual(
            renderedText(result),
            "Heading\nStrong emphasis link www.swift.org removed\nItem"
        )
        XCTAssertTrue(links(in: result).isEmpty)
        XCTAssertNil(result.inlinePresentationIntent)

        #if canImport(UIKit)
        for run in result.runs {
            XCTAssertNil(run.uiKit.font)
            XCTAssertNil(run.uiKit.foregroundColor)
            XCTAssertNil(run.uiKit.underlineStyle)
            XCTAssertNil(run.uiKit.strikethroughStyle)
        }
        #elseif canImport(SwiftUI)
        for run in result.runs {
            XCTAssertNil(run.swiftUI.font)
            XCTAssertNil(run.swiftUI.foregroundColor)
            XCTAssertNil(run.swiftUI.underlineStyle)
            XCTAssertNil(run.swiftUI.strikethroughStyle)
        }
        #endif
    }

    func testUnicodeAndExtendedGraphemeClustersRemainIntact() {
        let source = "👩🏽‍💻 Café e\u{301} **日本語** — https://例え.テスト/道?q=値#節"
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), "👩🏽‍💻 Café e\u{301} 日本語 — https://例え.テスト/道?q=値#節")
        XCTAssertEqual(links(in: result).map(\.text), ["https://例え.テスト/道?q=値#節"])
        XCTAssertEqual(links(in: result).first?.url.scheme?.lowercased(), "https")
        assertWellFormed(result)
    }

    func testLinkElementDisabled() {
        let result = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.link(.disabled)]
        )
            .attributedString(from: "[Markdown](https://example.com) and https://swift.org")

        XCTAssertEqual(renderedText(result), "Markdown and https://swift.org")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testSoftAndHardLineBreaksArePreserved() {
        XCTAssertEqual(renderedText(renderer().attributedString(from: "soft\nbreak")), "soft\nbreak")
        XCTAssertEqual(renderedText(renderer().attributedString(from: "hard  \nbreak")), "hard\nbreak")
    }

    func testImageBecomesPlainAltTextAndIsNotLinked() {
        let result = renderer().attributedString(
            from: "Before ![https://example.com](https://example.com/image.jpg) after"
        )

        XCTAssertEqual(renderedText(result), "Before https://example.com after")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testInlineCodeBecomesOrdinaryText() {
        let result = renderer().attributedString(from: "Use `https://example.com` now")

        XCTAssertEqual(renderedText(result), "Use https://example.com now")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testDisabledStrikethroughBecomesOrdinaryText() {
        let result = renderer().attributedString(from: "Keep ~~readable~~ text")

        XCTAssertEqual(renderedText(result), "Keep readable text")
        XCTAssertNil(result.inlinePresentationIntent)
    }

    func testUnsupportedBlocksFlattenPredictably() {
        let source = """
        # Heading

        > Quote

        | A | B |
        | - | - |
        | C | D |

        ```swift
        let value = 1
        ```
        """
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(
            renderedText(result),
            "Heading\nQuote\nA | B\nC | D\nlet value = 1\n"
        )
    }

    func testEmptyInput() {
        XCTAssertEqual(renderedText(renderer().attributedString(from: "")), "")
    }

    func testMalformedMarkdownRemainsReadable() {
        let source = "An **unfinished [piece"
        XCTAssertEqual(renderedText(renderer().attributedString(from: source)), source)
    }

    func testInvalidUnmarkedLinkIsNotLinked() {
        let result = renderer().attributedString(from: "Broken https:// is ordinary")

        XCTAssertEqual(renderedText(result), "Broken https:// is ordinary")
        XCTAssertTrue(links(in: result).isEmpty)
    }

    func testInvalidUnmarkedLinkCandidateDoesNotPreventLaterValidDetection() {
        let source = "Broken https:// then valid https://swift.org/path."
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), source)
        XCTAssertEqual(links(in: result).map(\.text), ["https://swift.org/path"])
    }

    func testRepeatedParsingDoesNotRetainTraversalState() {
        let renderer = renderer()

        _ = renderer.attributedString(from: "[linked](https://example.com)")
        let result = renderer.attributedString(from: "https://swift.org")

        XCTAssertEqual(links(in: result).map(\.url.absoluteString), ["https://swift.org"])
    }

    func testLargeNumberOfUnmarkedLinksAreAllDetectedWithoutChangingText() {
        let sources = (0..<300).map { index in
            "https://example.com/items/\(index)?source=feed#item-\(index)"
        }
        let source = sources.joined(separator: " | ")
        let result = renderer().attributedString(from: source)

        XCTAssertEqual(renderedText(result), source)
        XCTAssertEqual(links(in: result).map(\.text), sources)
        assertWellFormed(result)
    }

    func testAdversarialMarkdownCorpusIsDeterministicAndWellFormed() {
        let corpus = [
            "\0",
            "\r\nline\rline\n",
            "\tindented\ttext",
            String(repeating: "*", count: 257),
            String(repeating: "[", count: 128) + "text" + String(repeating: "]", count: 64),
            "[nested [label]](https://example.com/(a))",
            "<https://example.com> <not a url>",
            "https:// https:///missing-host www. .com",
            "`unterminated https://example.com",
            "<!-- raw --> <b>inline</b>",
            "- [x] done\n- [ ] pending\n  1. nested",
            "| A | B |\n| :- | -: |\n| **x** | https://example.com |",
            "مرحبا 日本語 Здравствуйте 👨‍👩‍👧‍👦 #naïve",
            "\\**escaped** and \\[not](https://example.com)",
        ]

        let renderer = renderer()
        for source in corpus {
            let first = renderer.attributedString(from: source)
            let second = renderer.attributedString(from: source)

            XCTAssertEqual(renderSignature(first), renderSignature(second), "Failed for \(source.debugDescription)")
            assertWellFormed(first)
            assertWellFormed(second)
        }
    }

    func testSeededGeneratedCorpusIsDeterministicAndWellFormed() {
        let tokens = [
            "plain", " ", "\n", "**", "*", "~~", "`", "[", "]", "(", ")",
            "https://example.com/a_(b)?q=1#f", "www.swift.org/path", "https://",
            "#Swift", "é", "日本語", "👩🏽‍💻", "<tag>", "- ", "1. ", "\\",
        ]
        var generator = SeededGenerator(seed: 0x5EED_F00D_CAFE_BEEF)
        let renderer = renderer()

        for iteration in 0..<500 {
            let tokenCount = Int.random(in: 1...24, using: &generator)
            let source = (0..<tokenCount)
                .map { _ in tokens.randomElement(using: &generator)! }
                .joined()
            let first = renderer.attributedString(from: source)
            let second = renderer.attributedString(from: source)

            XCTAssertEqual(
                renderSignature(first),
                renderSignature(second),
                "Generated case \(iteration) was not deterministic: \(source.debugDescription)"
            )
            assertWellFormed(first)
        }
    }

    func testConcurrentParsingUsesNoUnsafeSharedDetectorState() {
        let failures = LockedFailures()

        DispatchQueue.concurrentPerform(iterations: 300) { index in
            let source = "Post \(index): https://example.com/\(index), www.swift.org/\(index)."
            let result = MarkdownRenderer(appearance: enabledAppearance())
                .attributedString(from: source)
            let detected = links(in: result).map(\.text)
            let expected = ["https://example.com/\(index)", "www.swift.org/\(index)"]

            if renderedText(result) != source || detected != expected {
                failures.record("\(index): \(detected)")
            }
        }

        XCTAssertEqual(failures.values, [])
    }

    private func renderer() -> MarkdownRenderer {
        MarkdownRenderer(appearance: enabledAppearance())
    }

    private func assertSingleLink(
        source: String,
        text: String,
        destination: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let detectedLinks = links(in: renderer().attributedString(from: source))
        XCTAssertEqual(detectedLinks.map(\.text), [text], file: file, line: line)
        XCTAssertEqual(
            detectedLinks.map(\.url.absoluteString),
            [destination],
            file: file,
            line: line
        )
    }

    private func assertWellFormed(
        _ attributedString: AttributedString,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let reconstructed = attributedString.runs
            .map { String(attributedString[$0.range].characters) }
            .joined()

        XCTAssertEqual(reconstructed, renderedText(attributedString), file: file, line: line)
        for run in attributedString.runs {
            XCTAssertFalse(
                attributedString[run.range].characters.isEmpty,
                "AttributedString contained an empty run",
                file: file,
                line: line
            )
        }
    }

    private func renderSignature(_ attributedString: AttributedString) -> [String] {
        attributedString.runs.map { run in
            [
                String(attributedString[run.range].characters),
                run.link?.absoluteString ?? "-",
                String(describing: run.inlinePresentationIntent),
                String(describing: run[BaseTestAttribute.self]),
                String(describing: run[StrongTestAttribute.self]),
                String(describing: run[EmphasisTestAttribute.self]),
                String(describing: run[LinkTestAttribute.self]),
            ].joined(separator: "|")
        }
    }

    private func inlineIntent(
        at offset: Int,
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

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = 6364136223846793005 &* state &+ 1442695040888963407
        return state
    }
}

private final class LockedFailures: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [String] = []

    var values: [String] {
        lock.withLock { storage }
    }

    func record(_ failure: String) {
        lock.withLock {
            storage.append(failure)
        }
    }
}

private extension String {
    func firstOffsetForRendererTest(of substring: String) -> Int {
        guard let range = range(of: substring) else {
            XCTFail("Missing substring: \(substring)")
            return 0
        }
        return distance(from: startIndex, to: range.lowerBound)
    }
}
