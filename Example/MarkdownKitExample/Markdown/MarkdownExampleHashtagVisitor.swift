import Foundation
import MarkdownKit
import SwiftUI

struct MarkdownExampleHashtagVisitor: ICustomVisitor {

    // MARK: - Properties - Private

    private static let regularExpression = try! NSRegularExpression(
        pattern: #"(?<![\p{L}\p{M}\p{N}_])#[\p{L}\p{M}\p{N}_]+"#
    )

    // MARK: - ICustomVisitor

    func visit(attributedString: inout AttributedString) {
        let text = String(attributedString.characters)
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        let appearance = MarkdownTextAppearance()
            .foregroundStyle(.orange)
            .font(.body.bold())

        for match in Self.regularExpression.matches(in: text, range: fullRange).reversed() {
            guard let textRange = Range(match.range, in: text) else {
                continue
            }

            guard let lowerBound = AttributedString.Index(textRange.lowerBound, within: attributedString) else {
                continue
            }

            guard let upperBound = AttributedString.Index(textRange.upperBound, within: attributedString) else {
                continue
            }

            let attributedRange = lowerBound..<upperBound

            guard !attributedString[attributedRange].runs.contains(where: { $0.link != nil }) else {
                continue
            }

            let hashtag = String(text[textRange].dropFirst())
            guard
                let encodedHashtag = hashtag.addingPercentEncoding(
                    withAllowedCharacters: .urlPathAllowed
                ),
                let destination = URL(
                    string: "https://example.com/search/\(encodedHashtag)"
                )
            else {
                continue
            }

            attributedString[attributedRange].link = destination
            attributedString[attributedRange].mergeAttributes(appearance.container)
        }
    }
}
