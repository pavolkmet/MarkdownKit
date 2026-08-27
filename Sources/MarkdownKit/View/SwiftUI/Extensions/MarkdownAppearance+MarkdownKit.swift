import Foundation
import SwiftUI

public extension MarkdownAppearance {

    // MARK: - Computed Properties - Public

    /// Native SwiftUI appearance defaults inherited by ``MarkdownText``.
    static var swiftUI: MarkdownAppearance {
        var link = AttributeContainer()
        link.swiftUI.foregroundColor = .accentColor
        link.swiftUI.underlineStyle = .single

        var strikethrough = MarkdownDefaultStrikethroughVisitor.default
        strikethrough.swiftUI.strikethroughStyle = .single

        return MarkdownAppearance(
            textAppearance: .plain,
            linkAppearance: MarkdownTextAppearance(container: link),
            strongAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultStrongVisitor.default
            ),
            emphasisAppearance: MarkdownTextAppearance(
                container: MarkdownDefaultEmphasisVisitor.default
            ),
            headingAppearance: .swiftUI,
            strikethroughAppearance: MarkdownTextAppearance(container: strikethrough),
            unorderedListAppearance: MarkdownListAppearance(),
            orderedListAppearance: MarkdownListAppearance()
        )
    }
}
