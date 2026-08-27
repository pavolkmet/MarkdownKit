import Foundation
import XCTest

@testable import MarkdownKit

final class MarkdownDocumentTests: XCTestCase {

    // MARK: - Tests - Parsing

    func testInitializationPreservesSourceAndRenderedOutput() {
        let source = "# Heading\n\nRead **more** at https://example.com and visit #Swift."
        let document = MarkdownDocument(parsing: source)
        let renderer = MarkdownRenderer(appearance: enabledAppearance())

        XCTAssertEqual(document.source, source)
        XCTAssertEqual(
            renderer.attributedString(from: document),
            renderer.attributedString(from: source)
        )
    }

    // MARK: - Tests - Codable

    func testCodableRoundTripUsesTheOriginalMarkdownString() throws {
        let source = "Unicode #café 日本語 and **strong** text"
        let document = MarkdownDocument(parsing: source)
        let encodedDocument = try JSONEncoder().encode(document)
        let encodedSource = try JSONDecoder().decode(String.self, from: encodedDocument)
        let decodedDocument = try JSONDecoder().decode(MarkdownDocument.self, from: encodedDocument)

        XCTAssertEqual(encodedSource, source)
        XCTAssertEqual(decodedDocument.source, source)
        XCTAssertEqual(
            MarkdownRenderer().attributedString(from: decodedDocument),
            MarkdownRenderer().attributedString(from: document)
        )
    }

    func testResponseModelDecodesMarkdownStringDirectly() throws {
        let data = Data(#"{"text":"Hello **world** and #Hornet"}"#.utf8)
        let response = try JSONDecoder().decode(MarkdownDocumentResponse.self, from: data)

        XCTAssertEqual(response.text.source, "Hello **world** and #Hornet")
        XCTAssertEqual(
            renderedText(MarkdownRenderer().attributedString(from: response.text)),
            "Hello world and #Hornet"
        )
    }

    // MARK: - Tests - Concurrency

    func testDocumentIsSendable() {
        requireSendable(MarkdownDocument.self)
    }

    func testDocumentCanBeParsedInDetachedTask() async {
        let source = "Background **parsing** with https://example.com"
        let document = await Task.detached {
            MarkdownDocument(parsing: source)
        }.value

        XCTAssertEqual(document.source, source)
        XCTAssertEqual(
            renderedText(MarkdownRenderer().attributedString(from: document)),
            "Background parsing with https://example.com"
        )
    }

    func testDocumentCanBeRenderedConcurrently() async {
        let document = MarkdownDocument(
            parsing: "Read **more** at https://example.com and visit #Swift."
        )
        let results = await withTaskGroup(of: String.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    let attributedString = MarkdownRenderer(appearance: enabledAppearance())
                        .attributedString(from: document)
                    let destinations = links(in: attributedString)
                        .map(\.url.absoluteString)
                        .joined(separator: ",")

                    return "\(renderedText(attributedString))|\(destinations)"
                }
            }

            var results: [String] = []
            for await result in group {
                results.append(result)
            }
            return results
        }

        XCTAssertEqual(results.count, 100)
        XCTAssertEqual(
            Set(results),
            ["Read more at https://example.com and visit #Swift.|https://example.com"]
        )
    }
}

private struct MarkdownDocumentResponse: Codable, Sendable {
    let text: MarkdownDocument
}

private func requireSendable<Value: Sendable>(_ type: Value.Type) {}
