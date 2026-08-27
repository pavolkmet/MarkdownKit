import Markdown

extension ListItemContainer {

    // MARK: - Computed Properties - Internal

    /// The zero-based structural depth of this list inside other lists.
    var listDepth: Int {
        var depth = 0
        var ancestor = parent

        while let current = ancestor {
            if current is ListItemContainer {
                depth += 1
            }
            ancestor = current.parent
        }

        return depth
    }
}
