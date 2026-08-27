import Foundation

public extension IHeadingVisitor {

    // MARK: - Helper Methods - Public

    /// Renders heading children with attributes for the supplied level.
    mutating func visit(children: [AttributedString], level: Int) -> AttributedString {
        var result = children.concatenated
        let text = String(result.characters)
        guard let attributes = attributes(for: text, level: level) else {
            return result
        }

        result.mergeAttributes(attributes)
        return result
    }
}
