import Foundation
import XCTest

@testable import MarkdownKit

final class MarkdownPerformanceTests: XCTestCase {
    // **MARK: - Properties - Private**

    private let shortText = "A short **feed** item with https://example.com"

    private let mediumText = (0..<12).map { index in
        """
        ## Update \(index)

        This is a representative **feed post** with _emphasis_, [marked links](https://example.com/updates/\(index)), and an unmarked link https://example.com/profiles/\(index).

        - First item
        - Second item
        """
    }.joined(separator: "\n\n")

    private let longText = (0..<120).map { index in
        """
        ## Section \(index)

        This section contains **strong text**, _emphasized text_, `inline code`, a [marked link](https://example.com/sections/\(index)), and an unmarked link https://example.com/items/\(index)?source=benchmark#details.

        > A block quote used to exercise nested markup.

        1. First ordered item
        2. Second ordered item
        """
    }.joined(separator: "\n\n")

    private let feedCorpus = (0..<300).map { index in
        "Post \(index): **news** from https://example.com/items/\(index)?source=feed#summary"
    }

    private let listCorpus = (0..<300).map { index in
        "- Item **\(index)**\n  - Nested item [details](https://example.com/\(index))"
    }

    // **MARK: - Tests**

    func testShortTextPerformance() {
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for _ in 0..<300 {
                _ = renderer.attributedString(from: shortText)
            }
        }
    }

    func testShortDocumentPerformance() {
        let document = MarkdownDocument(parsing: shortText)
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for _ in 0..<300 {
                _ = renderer.attributedString(from: document)
            }
        }
    }

    func testMediumTextPerformance() {
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for _ in 0..<20 {
                _ = renderer.attributedString(from: mediumText)
            }
        }
    }

    func testMediumDocumentPerformance() {
        let document = MarkdownDocument(parsing: mediumText)
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for _ in 0..<20 {
                _ = renderer.attributedString(from: document)
            }
        }
    }

    func testLongTextPerformance() {
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            _ = renderer.attributedString(from: longText)
        }
    }

    func testLongDocumentPerformance() {
        let document = MarkdownDocument(parsing: longText)
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            _ = renderer.attributedString(from: document)
        }
    }

    func testRepeatedFeedParsingPerformance() {
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for source in feedCorpus {
                _ = renderer.attributedString(from: source)
            }
        }
    }

    func testUnmarkedLinkDetectionPerformance() {
        let renderer = MarkdownRenderer(
            appearance: MarkdownAppearance(
                text: AttributeContainer(),
                link: AttributeContainer()
            )
        )

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for source in feedCorpus {
                _ = renderer.attributedString(from: source)
            }
        }
    }

    func testListParsingPerformance() {
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for source in listCorpus {
                _ = renderer.attributedString(from: source)
            }
        }
    }

    func testCustomVisitorPerformance() {
        let renderer = MarkdownRenderer(
            elements: MarkdownElement.defaults + [.custom(PerformanceNoOpVisitor())],
            appearance: enabledAppearance()
        )

        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            for source in feedCorpus {
                _ = renderer.attributedString(from: source)
            }
        }
    }
}

private struct PerformanceNoOpVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {
        _ = attributedString.runs.count
    }
}
