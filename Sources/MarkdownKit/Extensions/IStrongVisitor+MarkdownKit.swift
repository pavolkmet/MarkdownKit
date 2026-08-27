import Foundation

public extension IStrongVisitor {

    // MARK: - Helper Methods - Public

    /// Renders strong children and records their semantic presentation intent.
    mutating func visit(children: [AttributedString]) -> AttributedString {
        var result = children.concatenated
        let text = String(result.characters)
        guard let attributes = attributes(for: text) else {
            return result
        }

        var intent = result.inlinePresentationIntent ?? []
        intent.insert(.stronglyEmphasized)
        result.inlinePresentationIntent = intent
        result.mergeAttributes(attributes)
        return result
    }

    /// Reapplies strong attributes after nested inline rendering is complete.
    mutating func finalize(attributedString: inout AttributedString) {
        let ranges = attributedString.runs.compactMap { run in
            if let intent = run.inlinePresentationIntent, intent.contains(.stronglyEmphasized) {
                return run.range
            } else {
                return nil
            }
        }

        for range in ranges {
            let text = String(attributedString[range].characters)
            if let attributes = attributes(for: text) {
                attributedString[range].mergeAttributes(attributes)
            }
        }
    }
}
