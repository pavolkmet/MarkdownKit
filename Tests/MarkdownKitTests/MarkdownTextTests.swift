import Markdown
import SwiftUI
import XCTest

@testable import MarkdownKit

@MainActor
final class MarkdownTextTests: XCTestCase {

    // MARK: - Tests - Rendering

    func testTextAndDocumentInitializersAcceptElementBaselines() {
        _ = MarkdownText(text: "**Text**", elements: [.strong(.default)])
        _ = MarkdownText(
            document: MarkdownDocument(parsing: "[#Reusable](https://example.com)"),
            elements: [.link(.default)]
        )
        _ = MarkdownText(
            document: Document(parsing: "[Link](https://example.com)"),
            elements: [.link(.default)]
        )
    }

    func testSwiftUIRendererProducesEquivalentTextAndDocumentOutput() {
        let source = "**Text** [Link](https://example.com)"
        let renderer = MarkdownRenderer(appearance: .swiftUI)

        XCTAssertEqual(
            renderer.attributedString(from: source),
            renderer.attributedString(from: Document(parsing: source))
        )
        XCTAssertEqual(
            renderer.attributedString(from: source),
            renderer.attributedString(from: MarkdownDocument(parsing: source))
        )
    }

    func testEnvironmentElementOverrideOrderDisablesInitializerLink() {
        let initializerElements = MarkdownElement.defaults
        let environmentElements: [MarkdownElement] = [.link(.disabled)]
        let result = MarkdownRenderer(
            elements: initializerElements + environmentElements,
            appearance: .swiftUI
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(String(result.characters), "Link")
        XCTAssertTrue(result.runs.allSatisfy { $0.link == nil })
    }

    func testEnvironmentAppearanceIsUsedByDefaultElement() {
        var appearance = MarkdownAppearance.swiftUI
        appearance.link = MarkdownTextAppearance().foregroundStyle(.orange)
        let result = MarkdownRenderer(
            elements: [.link(.default)],
            appearance: appearance
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(result.runs.first?.swiftUI.foregroundColor, .orange)
    }

    func testExplicitElementAppearanceOverridesEnvironmentAppearance() {
        var appearance = MarkdownAppearance.swiftUI
        appearance.link = MarkdownTextAppearance().foregroundStyle(.orange)
        let result = MarkdownRenderer(
            elements: [.link(.appearance(
                MarkdownTextAppearance().foregroundStyle(.purple)
            ))],
            appearance: appearance
        )
        .attributedString(from: "[Link](https://example.com)")

        XCTAssertEqual(result.runs.first?.swiftUI.foregroundColor, .purple)
    }

    func testConvenienceModifiersCoverCommonConfigurationPaths() {
        _ = MarkdownText(text: "Text")
            .markdownAppearance(.swiftUI)
            .markdownElements([.link(.default), .strong(.disabled)])
            .markdownElement(.paragraph(.default))
            .markdownText(.appearance(.plain))
            .markdownLink(.disabled)
            .markdownStrong(.default)
            .markdownEmphasis(.default)
            .markdownHeading(.default)
            .markdownStrikethrough(.default)
            .markdownOrderedList(.default)
            .markdownUnorderedList(.default)
            .markdownCustomVisitor(NoOpCustomVisitor())
    }

    // MARK: - Tests - Appearance

    func testSwiftUIAppearanceProvidesNativeHeadingAndLinkAttributes() {
        let appearance = MarkdownAppearance.swiftUI

        XCTAssertNil(appearance.text.container.swiftUI.font)
        XCTAssertNil(appearance.text.container.swiftUI.foregroundColor)
        XCTAssertEqual(appearance.heading.level1.swiftUI.font, .largeTitle)
        XCTAssertEqual(appearance.heading.level6.swiftUI.font, .subheadline)
        XCTAssertEqual(appearance.link.container.swiftUI.foregroundColor, .accentColor)
        XCTAssertEqual(appearance.link.container.swiftUI.underlineStyle, .single)
    }

    func testTextAppearanceSwiftUIModifiersRetainEarlierValues() {
        let appearance = MarkdownTextAppearance()
            .font(.body)
            .foregroundStyle(.orange)
            .underlineStyle(.single)

        XCTAssertEqual(appearance.container.swiftUI.font, .body)
        XCTAssertEqual(appearance.container.swiftUI.foregroundColor, .orange)
        XCTAssertEqual(appearance.container.swiftUI.underlineStyle, .single)
    }
}

private struct NoOpCustomVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {}
}
