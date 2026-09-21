# Changelog

All notable changes to MarkdownKit are documented in this file.

The project follows [Semantic Versioning](https://semver.org/).

## Unreleased

## 1.3.2 - 2026-09-21

### Fixed

- Optimized (Release) clients that link only the `MarkdownKit` product, such as dynamic framework
  targets in an Xcode project, no longer fail to link with an undefined
  `Markdown.Document.init(parsing:source:options:)` symbol. `MarkdownDocument(parsing:)`,
  `MarkdownRenderer.attributedString(from:)` for source text, and the visitor-based
  `MarkdownRenderer` initializers are now kept out of line, so cross-module optimization no longer
  inlines their `swift-markdown` calls into client code. Public API and behavior are unchanged.

## 1.3.1 - 2026-09-16

### Fixed

- Qualified the parsed document type in `MarkdownText` as `Markdown.Document`, resolving an
  ambiguity with SwiftUI's `Document` type when building with Xcode 27. Public API and behavior are
  unchanged.

## 1.3.0 - 2026-08-28

### Added

- Public `MarkdownRenderer(defaultElementsOverriddenBy:appearance:)` initialization for focused,
  ordered changes to the complete default visitor set.
- `Hashable` conformance for `MarkdownDocument`, using its exact original source as identity.
- GitHub-friendly Markdown guides covering setup, reusable documents, elements, visitors, SwiftUI
  configuration, application-owned processing, and supported Markdown nodes.
- This release changelog.

## 1.2.0 - 2026-08-27

### Added

- Release benchmarks for default and explicit-default renderer construction.
- Regression coverage proving that the default fast path installs every visitor and matches
  `MarkdownElement.defaults` followed by the same overrides.

### Changed

- Default renderer construction now creates the complete visitor set directly and resolves only
  actual overrides, reducing initialization time by approximately 56.5% in the reference benchmark.
- `MarkdownText` now distinguishes default and explicit element selections internally without
  changing existing call sites.

## 1.1.0 - 2026-08-27

### Added

- `MarkdownDocument`, a reusable `Codable` and `Sendable` representation that parses Markdown once.
- Rendering of reusable documents through `MarkdownText` and `MarkdownRenderer` with the current
  appearance and visitors.
- Background parsing, concurrent rendering, and source-preserving Codable tests.
- Complete SwiftUI environment documentation and a reusable-document example.

[Unreleased]: https://github.com/pavolkmet/MarkdownKit/compare/1.3.2...HEAD
[1.3.2]: https://github.com/pavolkmet/MarkdownKit/compare/1.3.1...1.3.2
[1.3.1]: https://github.com/pavolkmet/MarkdownKit/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/pavolkmet/MarkdownKit/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/pavolkmet/MarkdownKit/releases/tag/1.2.0
[1.1.0]: https://github.com/pavolkmet/MarkdownKit/releases/tag/1.1.0
