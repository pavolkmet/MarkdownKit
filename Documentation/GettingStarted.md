# Getting Started

Render Markdown with defaults, selected overrides, or a reusable renderer.

## Overview

### SwiftUI

Import MarkdownKit and create `MarkdownText` from source text:

```swift
import MarkdownKit
import SwiftUI

struct ArticleView: View {
    let source: String

    var body: some View {
        MarkdownText(text: source)
            .foregroundStyle(.primary)
    }
}
```

The default configuration uses native system fonts, semantic strong and emphasis attributes,
accent-colored links, readable line breaks, and literal list markers. Links are interactive without
enabling text selection.

Handle application destinations through SwiftUI's `openURL` environment value:

```swift
MarkdownText(text: "Open [Settings](my-app://settings).")
    .environment(\.openURL, OpenURLAction { url in
        handle(url)
        return .handled
    })
```

### Foundation

Use `MarkdownRenderer` when a view is not responsible for the resulting attributed string:

```swift
let renderer = MarkdownRenderer(
    defaultElementsOverriddenBy: [
        .link(.disabled),
    ]
)

let string = renderer.attributedString(
    from: "**MarkdownKit** keeps https://swift.org readable."
)
```

The override initializer starts with the complete default visitor set. Use `elements:` instead when
the supplied array should be the complete element selection.

### Next Steps

- [Parse response content once](ReusableDocuments.md).
- [Change individual Markdown behaviors](ConfiguringElements.md).
- [Apply inherited view configuration](SwiftUIConfiguration.md).
