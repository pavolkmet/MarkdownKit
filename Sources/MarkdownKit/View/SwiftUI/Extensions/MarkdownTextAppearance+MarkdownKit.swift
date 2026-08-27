import Foundation
import SwiftUI

public extension MarkdownTextAppearance {

    // MARK: - Helper Methods - Public

    /// Returns an appearance with the specified SwiftUI `Font`.
    func font(_ font: Font?) -> MarkdownTextAppearance {
        MarkdownTextAppearance(container: container.font(font))
    }

    /// Returns an appearance with the supplied foreground color.
    ///
    /// SwiftUI's attributed-string scope supports per-range colors, but not arbitrary shape styles.
    func foregroundStyle(_ color: Color?) -> MarkdownTextAppearance {
        var container = self.container
        container.swiftUI.foregroundColor = color
        return MarkdownTextAppearance(container: container)
    }

    /// Returns an appearance with the supplied underline style.
    func underlineStyle(_ style: Text.LineStyle?) -> MarkdownTextAppearance {
        var container = self.container
        container.swiftUI.underlineStyle = style
        return MarkdownTextAppearance(container: container)
    }

    /// Returns an appearance with the supplied strikethrough style.
    func strikethroughStyle(_ style: Text.LineStyle?) -> MarkdownTextAppearance {
        var container = self.container
        container.swiftUI.strikethroughStyle = style
        return MarkdownTextAppearance(container: container)
    }
}
