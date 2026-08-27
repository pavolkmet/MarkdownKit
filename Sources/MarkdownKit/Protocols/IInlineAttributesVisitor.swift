import Foundation

/// Renders inline content carrying an inline-attributes declaration.
public protocol IInlineAttributesVisitor {
    /// Returns the rendered attributed inline children.
    mutating func visit(children: [AttributedString], attributes: String) -> AttributedString
}
