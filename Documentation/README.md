# MarkdownKit Documentation

Render Markdown as a Foundation attributed string or native SwiftUI text with focused, replaceable visitors.

## Overview

MarkdownKit uses `swift-markdown` for parsing and gives every Markdown node a matching visitor.
Use the default configuration for native system styling, replace individual visitors when an
application owns specialized behavior, or supply a complete `MarkupVisitor` for full traversal
control.

For response models, `MarkdownDocument` parses source once and keeps presentation separate.
The reusable document is `Codable` and `Sendable`, while `MarkdownRenderer` and `MarkdownText`
apply the current appearance and visitors when rendering.

```swift
import MarkdownKit
import SwiftUI

struct PostView: View {
    let document: MarkdownDocument

    var body: some View {
        MarkdownText(document: document)
            .markdownLink(.default)
    }
}
```

## Guides

- [Getting Started](GettingStarted.md)
- [Reusable Documents](ReusableDocuments.md)
- [Configuring Elements and Visitors](ConfiguringElements.md)
- [Configuring SwiftUI Rendering](SwiftUIConfiguration.md)
- [Adding Application-Owned Visitors](ApplicationVisitors.md)
- [Supported Elements](SupportedElements.md)

## API Overview

### Rendering

- `MarkdownText`
- `MarkdownRenderer`
- `MarkdownDocument`

### Element Configuration

- `MarkdownElement`
- `MarkdownElementConfiguration`
- `MarkdownVisitorConfiguration`
- `MarkdownMarkupVisitors`

### Appearance

- `MarkdownAppearance`
- `MarkdownTextAppearance`
- `MarkdownHeadingAppearance`
- `MarkdownListAppearance`

### Primary Visitors

- `ITextVisitor`
- `ILinkVisitor`
- `IStrongVisitor`
- `IEmphasisVisitor`
- `IHeadingVisitor`
- `IStrikethroughVisitor`
- `ICustomVisitor`
