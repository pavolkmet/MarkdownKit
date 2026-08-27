import Foundation

/// Renders a documentation symbol link.
public protocol ISymbolLinkVisitor {
    /// Returns the rendered symbol destination.
    mutating func visit(destination: String?, visitor: inout any ITextVisitor) -> AttributedString
}
