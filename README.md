# MarkdownKit

MarkdownKit renders Markdown as a Foundation `AttributedString` or a native SwiftUI `MarkdownText`
view. It uses Apple’s [`swift-markdown`](https://github.com/swiftlang/swift-markdown) parser and a
small visitor for every Markdown node, so applications can replace exactly the behavior they own.

The package exposes one product and one module: `MarkdownKit`.

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
        from: "1.2.0"
    ),
]
```

Then add its single product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "MarkdownKit", package: "MarkdownKit"),
    ]
)
```

## Parse once in response models

`MarkdownDocument` is a presentation-independent, `Codable`, and `Sendable` representation of
parsed Markdown. A response model can use it directly when the server value is a Markdown string:

```swift
import MarkdownKit

struct PostResponse: Decodable, Sendable {
    let text: MarkdownDocument
}
```

Given this response:

```json
{
  "text": "Hello **world** and visit #Hornet"
}
```

decoding parses the Markdown exactly once. Decode away from the main actor when a response contains
enough Markdown to justify background work:

```swift
let response = try await Task.detached {
    try JSONDecoder().decode(PostResponse.self, from: data)
}.value
```

The parsed response can cross concurrency boundaries and render normally in SwiftUI:

```swift
MarkdownText(document: response.text)
```

`MarkdownDocument` retains the original source for lossless Codable round trips, while its parsed
tree contains no fonts, colors, or other visual attributes. Rendering therefore skips Markdown
parsing but still applies the current appearance, element configuration, and application visitors.

Hashtags and mentions remain ordinary text in the Markdown tree because their meaning belongs to
the application. A custom visitor detects them after the cached document is rendered, allowing the
application to choose their URL and appearance without reparsing the Markdown source.

## SwiftUI rendering

`MarkdownText` works out of the box with Dynamic Type heading fonts, semantic strong and emphasis
styles, accent-colored links, line breaks, and literal list markers:

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

You can also create and reuse a document explicitly:

```swift
import MarkdownKit

let document = MarkdownDocument(parsing: "# Parsed once")
let view = MarkdownText(document: document)
```

### Link interaction

Links in `MarkdownText` are interactive by default. Text selection is not required; use
`.textSelection(.enabled)` only when people should be able to copy the text.

Attach a custom `OpenURLAction` directly to `MarkdownText` when the application should handle a
destination itself:

```swift
MarkdownText(text: "Open [Settings](my-app://settings).")
    .environment(\.openURL, OpenURLAction { url in
        handle(url)
        return .handled
    })
```

Use `.onOpenURL` for URLs entering the application, not for taps on links inside `MarkdownText`.

## Appearance

`MarkdownAppearance` holds the shared appearance used by elements configured with `.default`:

- `text`, `link`, `strong`, `emphasis`, and `strikethrough` use `MarkdownTextAppearance`.
- `heading` uses a `MarkdownHeadingAppearance` container for each heading level.
- `orderedList` and `unorderedList` use `MarkdownListAppearance`.

SwiftUI conveniences return a new appearance, so they can be chained:

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

The underlying Foundation attributes always remain visible in `appearance.container`. This keeps
custom attributes explicit and allows the same appearance value to be passed to a default visitor.

## Selecting Markdown elements

Every supported Markdown type has a `MarkdownElement` case. Appearance-capable elements accept
four configurations:

| Configuration | Behavior |
| --- | --- |
| `.disabled` | Removes that element’s behavior while preserving readable content. |
| `.default` | Uses its default visitor and the shared `MarkdownAppearance`. |
| `.appearance(value)` | Uses its default visitor with an element-specific appearance. |
| `.visitor(value)` | Replaces the default visitor for that element. |

Structural elements use the same model without `.appearance`. Start with all defaults and append
only the decisions you want to override:

```swift
let elements = MarkdownElement.defaults + [
    .link(.appearance(linkAppearance)),
    .strikethrough(.disabled),
]

MarkdownText(text: text, elements: elements)
```

The last configuration for the same element wins. An omitted or disabled visitor flattens that
node into readable output; it does not discard the node’s text.

## SwiftUI environment configuration

MarkdownKit provides the following SwiftUI modifiers. They are inherited by descendant
`MarkdownText` views and are applied after the elements passed to the initializer.

| Modifier | Purpose |
| --- | --- |
| `.markdownAppearance(_:)` | Sets the shared appearance used by elements configured with `.default`. |
| `.markdownElements(_:)` | Appends several element overrides. |
| `.markdownElement(_:)` | Appends one override for any `MarkdownElement` case. |
| `.markdownText(_:)` | Configures the base text visitor or appearance. |
| `.markdownLink(_:)` | Configures Markdown and detected unmarked links. |
| `.markdownStrong(_:)` | Configures strongly emphasized text. |
| `.markdownEmphasis(_:)` | Configures emphasized text. |
| `.markdownHeading(_:)` | Configures all heading levels. |
| `.markdownStrikethrough(_:)` | Configures strikethrough text. |
| `.markdownOrderedList(_:)` | Configures ordered-list markers and layout. |
| `.markdownUnorderedList(_:)` | Configures unordered-list markers and layout. |
| `.markdownCustomVisitor(_:)` | Appends an application-owned final visitor, such as a hashtag visitor. |

Every element not represented by a typed convenience modifier remains available through
`.markdownElement(_:)` or `.markdownElements(_:)`. This includes documents, block quotes, code,
paragraphs, directives, images, line breaks, tables, Doxygen nodes, and every other
`MarkdownElement` case.

The corresponding public environment values are available when building a custom SwiftUI
container:

| Environment value | Value |
| --- | --- |
| `\.markdownAppearance` | The inherited `MarkdownAppearance`. |
| `\.markdownElementOverrides` | The ordered array of inherited `MarkdownElement` overrides. |

Parent-level configuration can combine shared appearance, focused overrides, and an
application-owned visitor:

```swift
MarkdownText(text: text)
    .markdownAppearance(appearance)
    .markdownLink(.disabled)
    .markdownCustomVisitor(MyHashtagVisitor())
```

Because `MarkdownText` produces a native SwiftUI `Text`, standard SwiftUI behavior remains
available as well:

| SwiftUI API | Typical use |
| --- | --- |
| `.font(_:)`, `.foregroundStyle(_:)`, `.dynamicTypeSize(_:)` | Supplies inherited text defaults and Dynamic Type limits. Explicit per-range Markdown attributes take precedence. |
| `.multilineTextAlignment(_:)`, `.lineSpacing(_:)` | Controls paragraph layout. |
| `.lineLimit(_:)`, `.truncationMode(_:)`, `.minimumScaleFactor(_:)` | Controls constrained text presentation. |
| `.textSelection(_:)` | Enables copying when required; it is not needed for link interaction. |
| `.environment(\.openURL, ...)` | Handles taps on Markdown, unmarked, hashtag, mention, and application-route links. |

## Foundation rendering

Use `MarkdownRenderer` when you need the attributed string without a SwiftUI view:

```swift
import MarkdownKit

let renderer = MarkdownRenderer(
    elements: MarkdownElement.defaults + [.link(.disabled)]
)

let attributedString = renderer.attributedString(
    from: "**MarkdownKit** keeps https://swift.org readable."
)
```

The renderer also accepts a reusable `MarkdownDocument`:

```swift
let document = MarkdownDocument(parsing: "# Parsed once")
let attributedString = renderer.attributedString(from: document)
```

For direct interoperability with `swift-markdown`, the renderer and `MarkdownText` also accept a
raw `Markdown.Document`.

`MarkdownRenderer` creates fresh traversal state for each render, so mutable value-type visitor
state does not leak between calls.

## Granular visitors

The seven primary customization seams are independent:

| Responsibility | Protocol |
| --- | --- |
| Base text | `ITextVisitor` |
| Markdown and unmarked links | `ILinkVisitor` |
| Strong | `IStrongVisitor` |
| Emphasis | `IEmphasisVisitor` |
| Headings | `IHeadingVisitor` |
| Strikethrough | `IStrikethroughVisitor` |
| Final application processing | `ICustomVisitor` |

There is also one protocol and one `MarkdownDefault…Visitor` type for every block, inline, table,
Doxygen, directive, document, list, and symbol node supported by `swift-markdown`.

Replace only the visitors you need:

```swift
let visitors = MarkdownMarkupVisitors(
    link: MyLinkVisitor(),
    heading: MarkdownDefaultHeadingVisitor(appearance: headingAppearance),
    custom: [MyHashtagVisitor()]
)

let renderer = MarkdownRenderer(visitors: visitors)
```

`ITextVisitor` is always present because it is the fallback for source text and generated markers.
All other focused visitors are optional. Setting one to `nil` keeps readable content while removing
that node’s specialized behavior.

### Links and unmarked links

`ILinkVisitor` receives the visible text, constructed `URL`, and `MarkdownLinkSource` (`.markdown`
or `.unmarked`). It decides whether a destination is accepted and which attributes to apply.
Returning `nil` leaves the range as ordinary text.

The built-in unmarked-link detector recognizes:

- `http://` and `https://` URLs;
- `www.` shorthand, normalized to HTTPS;
- custom schemes such as `spaces://`, `mailto:`, `tel:`, and `urn:`;
- balanced delimiters, ports, percent encoding, query strings, fragments, Unicode hosts, and common
  surrounding punctuation.

Set `shouldDetectUnmarkedLinks` to `false` in a custom link visitor to keep Markdown links without
scanning ordinary text.

### Application-owned visitors

Hashtags, mentions, and application routes belong to the consuming application. An
`ICustomVisitor` receives the final attributed string and can detect ranges, construct URLs, avoid
existing link ranges, and apply its own appearance.

The example project contains a Unicode-aware hashtag visitor using this path.

## Resolution order

MarkdownKit resolves configuration predictably:

1. `MarkdownText` starts with the initializer’s elements, which default to `MarkdownElement.defaults`.
2. Environment element overrides are appended after that baseline.
3. `.default` reads the shared environment `MarkdownAppearance`.
4. `.appearance` overrides the shared appearance for that element.
5. `.visitor` gives the element completely to the supplied visitor.
6. Ordered custom visitors run after all built-in rendering.

Base text attributes are applied first, followed by structural and inline attributes, links, and
finally application-owned custom visitors.

## Complete traversal replacement

You can replace the complete `swift-markdown` traversal when focused visitors are not enough:

```swift
import Foundation
import Markdown
import MarkdownKit

struct PlainTextVisitor: MarkupVisitor {
    mutating func defaultVisit(_ markup: Markup) -> AttributedString {
        markup.children.reduce(into: AttributedString()) { result, child in
            result.append(visit(child))
        }
    }

    mutating func visitText(_ text: Markdown.Text) -> AttributedString {
        AttributedString(text.string)
    }
}

let renderer = MarkdownRenderer(visitor: PlainTextVisitor())
```

## Example app

Open [`Example/MarkdownKitExample.xcodeproj`](Example/MarkdownKitExample.xcodeproj) and run the
`MarkdownKitExample` scheme. The minimal app uses the local package and demonstrates the native
`MarkdownText` view, shared appearance, Markdown and unmarked links, headings, inline styles,
nested lists, and an application-owned hashtag visitor.

## Tests

Run the package suite from the repository root:

```sh
swift test
```

The suite covers every default visitor, element enable/disable behavior, appearance precedence,
custom visitors, malformed and generated Markdown, Unicode, link detection, traversal isolation,
concurrent rendering, and performance smoke tests.

### Performance reference

Run the optimized performance suite with:

```sh
swift test -c release --filter MarkdownPerformanceTests
```

The suite measures clock time and memory over five samples. These release-build reference results
were recorded on August 27, 2026, using an 18-core Apple M5 Max MacBook Pro with 48 GB of memory
and macOS 26.5.2.

The paired tests compare parsing and rendering a source string on every call with rendering an
equivalent `MarkdownDocument` that was parsed before measurement:

| Workload | Input size | Renders per sample | String per render | Parsed document per render | Reduction |
| --- | ---: | ---: | ---: | ---: | ---: |
| Short feed text | 46 characters | 300 | 0.038 ms | 0.034 ms | 12.6% |
| Medium Markdown text | 2,380 characters | 20 | 1.41 ms | 1.28 ms | 9.1% |
| Long Markdown document | 37,228 characters | 1 | 18.45 ms | 16.73 ms | 9.3% |

Additional focused workloads provide these reference values:

| Workload | Items per sample | Average per sample | Average per item |
| --- | ---: | ---: | ---: |
| Feed corpus | 300 | 13.51 ms | 0.045 ms |
| Unmarked-link detection | 300 | 13.05 ms | 0.044 ms |
| Nested-list corpus | 300 | 18.92 ms | 0.063 ms |
| Custom visitor | 300 | 13.80 ms | 0.046 ms |

Default renderer construction now creates the complete visitor set directly instead of resolving
the `MarkdownElement.defaults` array one element at a time. Explicit element arrays retain their
existing ordered override behavior:

| Renderer construction | Initializations per sample | Average per sample | Average per renderer | Reduction |
| --- | ---: | ---: | ---: | ---: |
| Default elements | 10,000 | 13.60 ms | 0.0014 ms | 56.5% |
| Explicit `MarkdownElement.defaults` | 10,000 | 31.31 ms | 0.0031 ms | — |

Short and medium workloads run repeatedly inside each sample so their timings are large enough to
measure reliably. The long workload exercises headings, inline styles, marked and unmarked links,
block quotes, and ordered lists across 120 sections.

Pre-parsing removes repeated parser work, but traversal and attributed-string construction still
run for the current appearance and visitors. The primary application benefit is moving parsing to
response decoding away from the main actor and never repeating that work during SwiftUI updates.

These numbers are a reproducible development-machine reference, not an iPhone performance
guarantee. Device, OS version, build settings, input shape, enabled visitors, and attributed-string
attributes can change the result. For application validation, measure a release build on the target
iPhone with the Markdown content and surrounding UI used by the application.

## License

MarkdownKit is available under the MIT license. See [LICENSE](LICENSE).
