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
        from: "1.0.0"
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

## SwiftUI quick start

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

You can also render a document that was already parsed by `swift-markdown`:

```swift
import Markdown
import MarkdownKit

let document = Document(parsing: "# Parsed once")
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

SwiftUI environment modifiers are applied after the initializer elements, which makes parent-level
configuration straightforward:

```swift
MarkdownText(text: text)
    .markdownAppearance(appearance)
    .markdownLink(.disabled)
    .markdownCustomVisitor(MyHashtagVisitor())
```

Use `.markdownElement(...)` for any element, `.markdownElements(...)` for several, or the typed
modifiers for text, links, strong, emphasis, headings, strikethrough, and lists.

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

The renderer also accepts a `Markdown.Document`:

```swift
let attributedString = renderer.attributedString(from: document)
```

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

## License

MarkdownKit is available under the MIT license. See [LICENSE](LICENSE).
