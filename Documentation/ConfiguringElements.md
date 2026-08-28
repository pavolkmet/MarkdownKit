# Configuring Elements and Visitors

Choose default behavior, an appearance override, a custom visitor, or readable flattening for each Markdown node.

## Overview

### Override Selected Defaults

Use the default-override renderer initializer when every standard Markdown behavior should remain
enabled except for focused differences:

```swift
let renderer = MarkdownRenderer(
    defaultElementsOverriddenBy: [
        .link(.disabled),
        .strikethrough(.appearance(strikethroughAppearance)),
    ],
    appearance: appearance
)
```

Overrides are resolved in declaration order. The last configuration for the same element wins.

Use `elements:` when the array represents the complete supported selection:

```swift
let plainRenderer = MarkdownRenderer(
    elements: [
        .text(.default),
        .paragraph(.default),
    ]
)
```

An omitted or disabled visitor preserves readable content while removing that node's specialized
behavior.

### Choose an Element Configuration

Appearance-capable elements support four decisions:

- `.disabled` removes specialized behavior while keeping readable text.
- `.default` uses the matching default visitor and shared `MarkdownAppearance`.
- `.appearance(value)` uses the default visitor with a focused appearance.
- `.visitor(value)` replaces the default visitor for that element.

Structural elements use `MarkdownVisitorConfiguration` with `.disabled`, `.default`, and
`.visitor(value)`.

### Supply Visitors Directly

Use `MarkdownMarkupVisitors` when the application prefers named visitor properties over an
ordered element array:

```swift
let visitors = MarkdownMarkupVisitors(
    link: MyLinkVisitor(),
    heading: MarkdownDefaultHeadingVisitor(appearance: headingAppearance),
    custom: [MyHashtagVisitor()]
)

let renderer = MarkdownRenderer(visitors: visitors)
```

`ITextVisitor` is required because it renders source text and generated characters. Every other
focused visitor is optional.

### Replace the Complete Traversal

For behavior that cannot be expressed through focused visitors, initialize `MarkdownRenderer`
with a complete `MarkupVisitor` whose result is `AttributedString`. This is the lowest-level API;
focused visitors are preferable when only individual elements need customization.
