import Foundation
import XCTest

@testable import MarkdownKit

final class MarkdownPerformanceTests: XCTestCase {
    private let feedCorpus = (0..<300).map { index in
        "Post \(index): **news** from https://example.com/items/\(index)?source=feed#summary"
    }

    private let listCorpus = (0..<300).map { index in
        "- Item **\(index)**\n  - Nested item [details](https://example.com/\(index))"
    }

    func testFirstParsePerformance() {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            let renderer = MarkdownRenderer(appearance: enabledAppearance())
            _ = renderer.attributedString(from: "A short **feed** item with https://example.com")
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
