import Markdown

extension Markup {

    // MARK: - Computed Properties - Internal

    /// Returns whether the node is nested inside an explicit Markdown link.
    var isInsideLink: Bool {
        var ancestor = parent

        while let current = ancestor {
            if current is Link {
                return true
            }
            ancestor = current.parent
        }

        return false
    }
}
