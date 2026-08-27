import Foundation

/// Supplies base attributes for emitted text fragments, including generated separators and markers.
public protocol ITextVisitor {
    /// Returns the base attributes for a rendered text value.
    mutating func attributes(for text: String) -> AttributeContainer
}
