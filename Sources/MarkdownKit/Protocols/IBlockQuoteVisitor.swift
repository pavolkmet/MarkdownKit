import Foundation

/// Renders a block quote from its rendered block children.
public protocol IBlockQuoteVisitor {
    /// Returns the rendered block quote.
    mutating func visit(children: [AttributedString], visitor: inout any ITextVisitor) -> AttributedString
}
