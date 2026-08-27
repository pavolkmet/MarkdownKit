import Foundation

enum MarkdownUnmarkedLinkAttribute: AttributedStringKey {
    typealias Value = Bool
    static let name = "MarkdownKit.unmarkedLink"
}

enum MarkdownUnmarkedLinkDetector {

    // MARK: - DetectedLink

    private struct DetectedLink {
        let range: Range<String.Index>
        let destination: URL
    }

    // MARK: - Properties - Private

    private static let regularExpression = try! NSRegularExpression(
        pattern: #"(?i)(?<![\p{L}\p{N}_])(?:[a-z][a-z0-9+.-]*:|www\.)[^\s<>\"'“”‘’«»‹›]+"#
    )

    private static let trailingPunctuation: Set<Character> = [
        ".", ",", "!", "?", ";", ":",
        "”", "’", "»", "›", "…",
        "。", "，", "！", "？", "；", "：",
    ]

    private static let pairedDelimiters: [(opening: Character, closing: Character)] = [
        ("(", ")"),
        ("[", "]"),
        ("{", "}"),
    ]

    private static let schemesRequiringHost: Set<String> = [
        "http",
        "https",
    ]

    // MARK: - Helper Methods - Internal

    static func attributedString(from text: String, visitor: inout any ITextVisitor) -> AttributedString {
        let matches = regularExpression.matches(
            in: text,
            range: NSRange(text.startIndex..<text.endIndex, in: text)
        )
        guard matches.isEmpty == false else {
            return visitor.visit(text: text)
        }

        var result = AttributedString()
        var cursor = text.startIndex

        for match in matches {
            guard let link = detectedLink(from: match, in: text) else {
                continue
            }

            if cursor < link.range.lowerBound {
                result.append(visitor.visit(text: String(text[cursor..<link.range.lowerBound])))
            }

            var linkedText = visitor.visit(text: String(text[link.range]))
            linkedText.link = link.destination
            linkedText[MarkdownUnmarkedLinkAttribute.self] = true
            result.append(linkedText)
            cursor = link.range.upperBound
        }

        if cursor < text.endIndex {
            result.append(visitor.visit(text: String(text[cursor...])))
        }

        return result
    }

    // MARK: - Helper Methods - Private

    private static func detectedLink(from match: NSTextCheckingResult, in text: String) -> DetectedLink? {
        guard let range = detectedRange(from: match, in: text) else {
            return nil
        }

        let value = String(text[range])
        guard let destination = destination(from: value) else {
            return nil
        }

        return DetectedLink(range: range, destination: destination)
    }

    private static func detectedRange(from match: NSTextCheckingResult, in text: String) -> Range<String.Index>? {
        guard let range = Range(match.range, in: text) else {
            return nil
        }

        var upperBound = range.upperBound
        while upperBound > range.lowerBound {
            let lastIndex = text.index(before: upperBound)
            guard trailingPunctuation.contains(text[lastIndex]) else {
                break
            }

            upperBound = lastIndex
        }

        for delimiter in pairedDelimiters {
            let candidate = text[range.lowerBound..<upperBound]
            let openingCount = candidate.filter { $0 == delimiter.opening }.count
            var surplusClosingCount = candidate.filter { $0 == delimiter.closing }.count - openingCount

            while surplusClosingCount > 0, upperBound > range.lowerBound {
                let lastIndex = text.index(before: upperBound)
                guard text[lastIndex] == delimiter.closing else {
                    break
                }

                upperBound = lastIndex
                surplusClosingCount -= 1
            }
        }

        guard upperBound > range.lowerBound else {
            return nil
        }

        return range.lowerBound..<upperBound
    }

    private static func destination(from value: String) -> URL? {
        let normalizedValue: String
        if value.lowercased().hasPrefix("www.") {
            normalizedValue = "https://\(value)"
        } else {
            normalizedValue = value
        }

        guard let destination = URL(string: normalizedValue) else {
            return nil
        }

        guard let scheme = destination.scheme else {
            return nil
        }

        let valueAfterScheme = normalizedValue.dropFirst(scheme.count + 1)
        guard valueAfterScheme.contains(where: { $0 != "/" }) else {
            return nil
        }

        if schemesRequiringHost.contains(scheme.lowercased()) {
            guard let host = destination.host else {
                return nil
            }

            guard host.isEmpty == false else {
                return nil
            }
        }

        return destination
    }
}
