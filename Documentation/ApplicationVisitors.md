# Adding Application-Owned Visitors

Detect hashtags, mentions, routes, and other application semantics after built-in Markdown rendering.

## Overview

### Use a Custom Visitor

Markdown syntax does not assign meaning to hashtags or mentions. An `ICustomVisitor` receives the
fully rendered attributed string and can add application-specific links and attributes:

```swift
struct HashtagVisitor: ICustomVisitor {
    func visit(attributedString: inout AttributedString) {
        // Detect hashtag ranges, avoid existing links, then apply
        // the application's destination and appearance.
    }
}

MarkdownText(text: "Explore #Swift")
    .markdownCustomVisitor(HashtagVisitor())
```

Custom visitors run in declaration order after built-in rendering. A visitor should preserve ranges
owned by earlier processing unless intentionally replacing them.

### Customize Markdown and Unmarked Links

`ILinkVisitor` receives visible text, a constructed `URL`, and `MarkdownLinkSource`. The source
distinguishes explicit Markdown links from detected unmarked links:

```swift
struct ApplicationLinkVisitor: ILinkVisitor {
    var shouldDetectUnmarkedLinks: Bool { true }

    func attributes(for text: String, destination: URL, source: MarkdownLinkSource) -> AttributeContainer? {
        var attributes = AttributeContainer()
        attributes.link = destination
        return attributes
    }
}
```

Return `nil` to leave a destination as ordinary text. Set `shouldDetectUnmarkedLinks` to `false` to
retain explicit Markdown links without scanning ordinary text.

### Supported Unmarked Destinations

The built-in detector recognizes HTTP and HTTPS, `www.` shorthand, and custom schemes such as
`mailto:`, `tel:`, `urn:`, and application routes. It preserves balanced delimiters, ports, percent
encoding, query strings, and fragments while excluding common surrounding punctuation.
