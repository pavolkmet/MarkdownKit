# Configuring SwiftUI Rendering

Apply shared appearance and ordered element overrides through the SwiftUI environment.

## Overview

### Apply an Appearance

`MarkdownAppearance` describes presentation without deciding which elements are enabled:

```swift
let linkAppearance = MarkdownTextAppearance()
    .font(.system(size: 17, weight: .bold))
    .foregroundStyle(.orange)
    .underlineStyle(.single)

var appearance = MarkdownAppearance.swiftUI
appearance.link = linkAppearance

MarkdownText(text: source)
    .markdownAppearance(appearance)
```

The underlying Foundation attributes remain available through each appearance's `container`.

### Override Descendant Elements

SwiftUI modifiers append inherited element overrides after the `MarkdownText` initializer's
baseline:

```swift
MarkdownText(text: source)
    .markdownLink(.disabled)
    .markdownStrong(.default)
    .markdownCustomVisitor(MyHashtagVisitor())
```

Typed modifiers cover text, links, strong, emphasis, headings, strikethrough, and ordered and
unordered lists. Use `.markdownElement(_:)` or `.markdownElements(_:)` for every other
`MarkdownElement` case.

The corresponding public environment values are:

- `EnvironmentValues.markdownAppearance`
- `EnvironmentValues.markdownElementOverrides`

These values are useful when building a custom container around descendant Markdown views.

### Continue Using Native Text Modifiers

`MarkdownText` produces native SwiftUI `Text`, so standard modifiers remain available:

- `.font(_:)`, `.foregroundStyle(_:)`, and `.dynamicTypeSize(_:)`
- `.multilineTextAlignment(_:)` and `.lineSpacing(_:)`
- `.lineLimit(_:)`, `.truncationMode(_:)`, and `.minimumScaleFactor(_:)`
- `.textSelection(_:)` when copying should be enabled
- `.environment(\.openURL, ...)` for link interaction

Explicit per-range Markdown attributes take precedence over inherited text defaults.
