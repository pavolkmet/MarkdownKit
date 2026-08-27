import Foundation

public extension IStrikethroughVisitor {

    // MARK: - Helper Methods - Public

    /// Renders strikethrough children and records their semantic presentation intent.
    mutating func visit(children: [AttributedString]) -> AttributedString {
        var result = children.concatenated
        let text = String(result.characters)
        guard let attributes = attributes(for: text) else {
            return result
        }

        var intent = result.inlinePresentationIntent ?? []
        intent.insert(.strikethrough)
        result.inlinePresentationIntent = intent
        result.mergeAttributes(attributes)
        return result
    }
}
