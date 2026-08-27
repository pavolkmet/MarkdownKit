import SwiftUI

private struct MarkdownAppearanceEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = MarkdownAppearance.swiftUI
}

private struct MarkdownElementOverridesEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: [MarkdownElement] = []
}

public extension EnvironmentValues {

    // MARK: - Properties - Public

    /// The appearance inherited by descendant ``MarkdownText`` views.
    var markdownAppearance: MarkdownAppearance {
        get { self[MarkdownAppearanceEnvironmentKey.self] }
        set { self[MarkdownAppearanceEnvironmentKey.self] = newValue }
    }

    /// Markdown element configurations appended to each descendant ``MarkdownText`` view.
    var markdownElementOverrides: [MarkdownElement] {
        get { self[MarkdownElementOverridesEnvironmentKey.self] }
        set { self[MarkdownElementOverridesEnvironmentKey.self] = newValue }
    }
}
