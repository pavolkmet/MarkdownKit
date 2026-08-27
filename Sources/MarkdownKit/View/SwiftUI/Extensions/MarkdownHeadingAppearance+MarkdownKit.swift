import Foundation
import SwiftUI

public extension MarkdownHeadingAppearance {

    // MARK: - Computed Properties - Public

    /// Dynamic Type heading fonts for native SwiftUI rendering.
    static var swiftUI: MarkdownHeadingAppearance {
        MarkdownHeadingAppearance(
            level1: AttributeContainer().font(.largeTitle),
            level2: AttributeContainer().font(.title),
            level3: AttributeContainer().font(.title2),
            level4: AttributeContainer().font(.title3),
            level5: AttributeContainer().font(.headline),
            level6: AttributeContainer().font(.subheadline)
        )
    }
}
