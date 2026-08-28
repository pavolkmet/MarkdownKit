import Foundation
import XCTest

import MarkdownKit

final class MarkdownRendererPublicAPITests: XCTestCase {

    // MARK: - Tests

    func testDefaultElementOverridesInitializerIsPublicAndPreservesOtherDefaults() {
        let renderer = MarkdownRenderer(
            defaultElementsOverriddenBy: [.link(.disabled)]
        )
        let result = renderer.attributedString(
            from: "# **Title** [Link](https://example.com)"
        )

        XCTAssertEqual(String(result.characters), "Title Link")
        XCTAssertTrue(result.runs.allSatisfy { $0.link == nil })
        XCTAssertTrue(result.runs.contains { run in
            run.inlinePresentationIntent?.contains(.stronglyEmphasized) == true
        })
    }
}
