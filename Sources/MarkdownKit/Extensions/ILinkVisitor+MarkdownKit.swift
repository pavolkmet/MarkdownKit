import Foundation

public extension ILinkVisitor {

    // MARK: - Computed Properties - Public

    /// Custom link visitors detect unmarked links unless they explicitly opt out.
    var shouldDetectUnmarkedLinks: Bool { true }

    // MARK: - Helper Methods - Public

    /// Adds a parsed Markdown destination to rendered link children.
    mutating func visit(children: [AttributedString], destination: String?) -> AttributedString {
        var result = children.concatenated
        guard
            let destination,
            let url = URL(string: destination)
        else {
            return result
        }

        result.link = url
        return result
    }

    /// Renders ordinary text and optionally detects unmarked links within it.
    mutating func visit(text: String, isInsideLink: Bool, visitor: inout any ITextVisitor) -> AttributedString {
        guard shouldDetectUnmarkedLinks, isInsideLink == false else {
            return visitor.visit(text: text)
        }

        return MarkdownUnmarkedLinkDetector.attributedString(
            from: text,
            visitor: &visitor
        )
    }

    /// Applies source-aware link attributes after the complete document is rendered.
    mutating func finalize(attributedString: inout AttributedString) {
        let links = attributedString.runs.compactMap { run -> MarkdownRenderedLink? in
            guard let destination = run.link else {
                return nil
            }

            let source: MarkdownLinkSource
            if run[MarkdownUnmarkedLinkAttribute.self] == true {
                source = .unmarked
            } else {
                source = .markdown
            }

            return MarkdownRenderedLink(
                range: run.range,
                destination: destination,
                source: source
            )
        }

        for link in links {
            let text = String(attributedString[link.range].characters)
            if let attributes = attributes(
                for: text,
                destination: link.destination,
                source: link.source
            ) {
                attributedString[link.range].mergeAttributes(attributes)
            } else {
                attributedString[link.range].link = nil
            }

            attributedString[link.range][MarkdownUnmarkedLinkAttribute.self] = nil
        }
    }
}

private struct MarkdownRenderedLink {

    // MARK: - Properties - Private

    let range: Range<AttributedString.Index>
    let destination: URL
    let source: MarkdownLinkSource
}
