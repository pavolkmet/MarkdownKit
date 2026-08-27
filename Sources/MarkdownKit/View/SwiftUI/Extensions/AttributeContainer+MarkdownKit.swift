import Foundation
import SwiftUI

extension AttributeContainer {

    // MARK: - Helper Methods - Internal

    /// Returns a container with the specified SwiftUI font.
    func font(_ font: Font?) -> AttributeContainer {
        var container = self
        container.swiftUI.font = font
        return container
    }
}
