# Reusable Documents

Parse Markdown during response decoding and render it later with the current presentation.

## Overview

### Decode Markdown Directly

`MarkdownDocument` is `Codable`, `Hashable`, and `Sendable`. It decodes from and encodes to a single
Markdown string, so a response model can store the parsed document directly:

```swift
import MarkdownKit

struct PostResponse: Decodable, Sendable {
    let id: String
    let text: MarkdownDocument
}
```

Decode away from the main actor when a response contains enough Markdown to justify background
work:

```swift
let response = try await Task.detached {
    try JSONDecoder().decode(PostResponse.self, from: data)
}.value
```

The document can then cross concurrency boundaries and render normally:

```swift
MarkdownText(document: response.text)
```

### Keep Parsing and Presentation Separate

A reusable document stores the original source and an immutable parsed tree. It does not store
fonts, colors, visitor output, or a rendered attributed string. Rendering therefore skips parsing
while still respecting the current `MarkdownAppearance`, element configuration, and custom
visitors.

```swift
let renderer = MarkdownRenderer(appearance: appearance)
let string = renderer.attributedString(from: response.text)
```

This separation allows one parsed response to render with different appearances without reparsing
its source.

Equality and hashing use the exact original Markdown source. This makes documents safe dictionary
keys and set members while keeping differently authored Markdown distinct, even when it produces
the same rendered output.

### Manage Feed Lifetime in the Application

Each reusable document retains its source and parsed tree. Keep documents with the response models
that are useful to the application, and release old feed pages through the application's existing
pagination or cache policy. Avoid a permanent global document cache unless measurements show that
the content is reused enough to justify it.
