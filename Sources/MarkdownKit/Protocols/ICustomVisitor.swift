import Foundation

/// A post-processing operation that can add application-specific attributes to parsed Markdown.
public protocol ICustomVisitor {
    /// Mutates the fully rendered Markdown output.
    func visit(attributedString: inout AttributedString)
}
