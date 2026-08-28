# MarkdownKit

MarkdownKit renders Markdown as a Foundation `AttributedString` or native SwiftUI `Text`. It uses
Apple's [`swift-markdown`](https://github.com/swiftlang/swift-markdown) parser and exposes a focused
visitor for every Markdown node, so applications can replace only the behavior they own.

- Native system styling and Dynamic Type out of the box
- One configurable visitor for every supported Markdown element
- Markdown and unmarked-link detection, including custom URL schemes
- Application-owned processing for hashtags, mentions, and routes
- Reusable `Codable` and `Sendable` documents for background parsing
- One package product and one import: `MarkdownKit`

## Requirements

- Swift 6.0 or later
- iOS 15 or later
- macOS 12 or later
- `swift-markdown` 0.8.0

## Installation

Add MarkdownKit through Swift Package Manager:

```swift
dependencies: [
    .package(
        url: "https://github.com/pavolkmet/MarkdownKit.git",
        from: "1.3.0"
    ),
]
```

Then add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "MarkdownKit", package: "MarkdownKit"),
    ]
)
```

## Quick Start

### SwiftUI

`MarkdownText` works with the standard SwiftUI text modifiers:

```swift
import MarkdownKit
import SwiftUI

struct ArticleView: View {
    let text: String

    var body: some View {
        MarkdownText(text: text)
            .foregroundStyle(.primary)
    }
}
```

Links are interactive without enabling text selection. Attach an `OpenURLAction` when the
application should handle a destination itself:

```swift
MarkdownText(text: "Open [Settings](my-app://settings).")
    .environment(\.openURL, OpenURLAction { url in
        handle(url)
        return .handled
    })
```

Use `.textSelection(.enabled)` only when people should also be able to copy the text.

### Foundation

Use `MarkdownRenderer` when a view is not responsible for the resulting attributed string:

```swift
import MarkdownKit

let renderer = MarkdownRenderer(
    defaultElementsOverriddenBy: [.link(.disabled)]
)

let attributedString = renderer.attributedString(
    from: "**MarkdownKit** keeps https://swift.org readable."
)
```

The default-override initializer preserves every standard behavior and changes only the supplied
elements. Use `elements:` when the array represents the complete supported selection.

## Parse Once, Render Anywhere

`MarkdownDocument` is a presentation-independent, `Codable`, and `Sendable` representation of
parsed Markdown. Response models can store it directly when the server value is a Markdown string:

```swift
struct PostResponse: Decodable, Sendable {
    let id: String
    let text: MarkdownDocument
}
```

Decode away from the main actor when the content is large enough to justify background work:

```swift
let response = try await Task.detached {
    try JSONDecoder().decode(PostResponse.self, from: data)
}.value
```

The document can then cross concurrency boundaries and render with the current appearance and
visitors without parsing its source again:

```swift
MarkdownText(document: response.text)
```

The document contains no fonts, colors, or rendered attributes. The same parsed response can
therefore use different presentation in different parts of the application. See
[Reusable Documents](Documentation/ReusableDocuments.md) for lifecycle and caching guidance.

## Appearance

`MarkdownAppearance` supplies the shared appearance for elements configured with `.default`:

```swift
let linkAppearance = MarkdownTextAppearance()
    .font(.system(size: 17, weight: .bold))
    .foregroundStyle(.orange)
    .underlineStyle(.single)

var appearance = MarkdownAppearance.swiftUI
appearance.link = linkAppearance

MarkdownText(text: "Open [Swift](https://swift.org).")
    .markdownAppearance(appearance)
```

The underlying `AttributeContainer` remains available through each appearance's `container`.

## Element Configuration

Every supported Markdown type has a `MarkdownElement` case. Appearance-capable elements accept:

| Configuration | Behavior |
| --- | --- |
| `.disabled` | Removes specialized behavior while preserving readable content. |
| `.default` | Uses the default visitor and shared `MarkdownAppearance`. |
| `.appearance(value)` | Uses the default visitor with a focused appearance. |
| `.visitor(value)` | Replaces the default visitor for that element. |

Structural elements provide the same model without `.appearance`. The last configuration for the
same element wins:

```swift
MarkdownText(
    text: text,
    elements: MarkdownElement.defaults + [
        .link(.appearance(linkAppearance)),
        .strikethrough(.disabled),
    ]
)
```

An omitted or disabled visitor flattens its node into readable text; it does not discard the node's
content. The complete list is available in [Supported Elements](Documentation/SupportedElements.md).

## SwiftUI Configuration

Environment modifiers are inherited by descendant `MarkdownText` views and applied after the
elements passed to the initializer.

| Modifier | Purpose |
| --- | --- |
| `.markdownAppearance(_:)` | Sets the shared default appearance. |
| `.markdownElements(_:)` | Appends several element overrides. |
| `.markdownElement(_:)` | Appends one override for any `MarkdownElement`. |
| `.markdownText(_:)` | Configures base text. |
| `.markdownLink(_:)` | Configures Markdown and detected unmarked links. |
| `.markdownStrong(_:)` | Configures strongly emphasized text. |
| `.markdownEmphasis(_:)` | Configures emphasized text. |
| `.markdownHeading(_:)` | Configures every heading level. |
| `.markdownStrikethrough(_:)` | Configures strikethrough text. |
| `.markdownOrderedList(_:)` | Configures ordered lists. |
| `.markdownUnorderedList(_:)` | Configures unordered lists. |
| `.markdownCustomVisitor(_:)` | Appends application-owned final processing. |

Every remaining element is available through `.markdownElement(_:)` and
`.markdownElements(_:)`. Custom containers can also read `EnvironmentValues.markdownAppearance`
and `EnvironmentValues.markdownElementOverrides` directly.

Because `MarkdownText` produces native SwiftUI `Text`, `.font(_:)`, `.foregroundStyle(_:)`,
`.dynamicTypeSize(_:)`, multiline layout, truncation, selection, and `openURL` handling remain
available. See [Configuring SwiftUI Rendering](Documentation/SwiftUIConfiguration.md) for details.

## Granular Visitors

The seven primary customization seams remain independent:

| Responsibility | Protocol |
| --- | --- |
| Base text | `ITextVisitor` |
| Markdown and unmarked links | `ILinkVisitor` |
| Strong | `IStrongVisitor` |
| Emphasis | `IEmphasisVisitor` |
| Headings | `IHeadingVisitor` |
| Strikethrough | `IStrikethroughVisitor` |
| Final application processing | `ICustomVisitor` |

There is also one protocol and one `MarkdownDefault…Visitor` for every block, inline, table,
Doxygen, directive, document, list, and symbol node supported by `swift-markdown`.

```swift
let visitors = MarkdownMarkupVisitors(
    link: MyLinkVisitor(),
    heading: MarkdownDefaultHeadingVisitor(appearance: headingAppearance),
    custom: [MyHashtagVisitor()]
)

let renderer = MarkdownRenderer(visitors: visitors)
```

`ITextVisitor` is always present because it renders source text and generated markers. Every other
focused visitor is optional. See [Adding Application-Owned Visitors](Documentation/ApplicationVisitors.md)
for custom hashtags and links.

## Links and Unmarked Links

`ILinkVisitor` receives visible text, a constructed `URL`, and a `MarkdownLinkSource` of either
`.markdown` or `.unmarked`. Returning `nil` leaves the range as ordinary text.

The built-in unmarked-link detector recognizes:

- HTTP and HTTPS URLs
- `www.` shorthand normalized to HTTPS
- Custom schemes such as `spaces:`, `mailto:`, `tel:`, and `urn:`
- Balanced delimiters, ports, percent encoding, queries, fragments, Unicode hosts, and surrounding
  punctuation

Set `shouldDetectUnmarkedLinks` to `false` to preserve explicit Markdown links without scanning
ordinary text.

## Documentation

The guides are ordinary Markdown files designed to be read directly on GitHub:

- [Getting Started](Documentation/GettingStarted.md)
- [Reusable Documents](Documentation/ReusableDocuments.md)
- [Configuring Elements and Visitors](Documentation/ConfiguringElements.md)
- [Configuring SwiftUI Rendering](Documentation/SwiftUIConfiguration.md)
- [Adding Application-Owned Visitors](Documentation/ApplicationVisitors.md)
- [Supported Elements](Documentation/SupportedElements.md)
- [Documentation Index](Documentation/README.md)
- [Changelog](CHANGELOG.md)

Public declarations also include `///` documentation for Xcode Quick Help and code completion.

## Example App

Open [`Example/MarkdownKitExample.xcodeproj`](Example/MarkdownKitExample.xcodeproj) and run the
`MarkdownKitExample` scheme. The minimal app demonstrates `MarkdownText`, shared appearance,
Markdown and unmarked links, headings, inline styles, nested lists, `openURL`, and an
application-owned hashtag visitor.

## Performance

Run the optimized performance suite with:

```sh
swift test -c release --filter MarkdownPerformanceTests
```

The following release-build reference was recorded on August 27, 2026, using an 18-core Apple M5
Max MacBook Pro with 48 GB of memory and macOS 26.5.2. Each value is the average of five samples.

| Workload | Input size | Renders per sample | String per render | Parsed document per render | Reduction |
| --- | ---: | ---: | ---: | ---: | ---: |
| Short feed text | 46 characters | 300 | 0.038 ms | 0.034 ms | 12.6% |
| Medium Markdown text | 2,380 characters | 20 | 1.41 ms | 1.28 ms | 9.1% |
| Long Markdown document | 37,228 characters | 1 | 18.45 ms | 16.73 ms | 9.3% |

Focused workloads provide these additional reference values:

| Workload | Items per sample | Average per sample | Average per item |
| --- | ---: | ---: | ---: |
| Feed corpus | 300 | 13.51 ms | 0.045 ms |
| Unmarked-link detection | 300 | 13.05 ms | 0.044 ms |
| Nested-list corpus | 300 | 18.92 ms | 0.063 ms |
| Custom visitor | 300 | 13.80 ms | 0.046 ms |

Default renderer construction uses the direct complete-visitor fast path:

| Renderer construction | Initializations per sample | Average per sample | Average per renderer | Reduction |
| --- | ---: | ---: | ---: | ---: |
| Default elements | 10,000 | 13.60 ms | 0.0014 ms | 56.5% |
| Explicit `MarkdownElement.defaults` | 10,000 | 31.31 ms | 0.0031 ms | — |

Pre-parsing removes repeated parser work, while traversal and attributed-string construction still
run for the current appearance and visitors. Its main application benefit is moving parsing to
response decoding and avoiding that work during SwiftUI updates.

These figures are reproducible development-machine references, not iPhone guarantees. Measure a
release build on the target device with representative Markdown and surrounding UI before making
application-level performance decisions.

## Tests

Run the complete package suite from the repository root:

```sh
swift test
```

The suite covers every default visitor, configuration precedence, custom processing, malformed and
generated Markdown, Unicode, link detection, traversal isolation, concurrent rendering, and
performance smoke tests.

## License

MarkdownKit is available under the MIT license. See [LICENSE](LICENSE).
