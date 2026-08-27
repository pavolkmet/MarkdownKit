import Foundation

public extension ITextVisitor {

    // MARK: - Helper Methods - Public

    /// Renders a text value with the visitor's base attributes.
    mutating func visit(text: String) -> AttributedString {
        AttributedString(text, attributes: attributes(for: text))
    }
}
