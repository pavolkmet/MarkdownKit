# MarkdownKit Example

`MarkdownKitExample.xcodeproj` is a small SwiftUI app backed by the local MarkdownKit package.

Open the project and run the `MarkdownKitExample` scheme on an iOS 15 or later
Simulator. The app immediately renders a native `MarkdownText` view.

The sample demonstrates a reusable `MarkdownDocument`, text formatting, Markdown and unmarked
links, nested lists, SwiftUI appearance configuration, and an app-owned hashtag visitor.

The example mirrors the package structure:

```text
MarkdownKitExample/
├── App/
├── Markdown/
│   └── MarkdownExampleHashtagVisitor.swift
└── Views/
    └── ContentView.swift
```

From the repository root, compile the project with:

```sh
xcodebuild \
  -project Example/MarkdownKitExample.xcodeproj \
  -scheme MarkdownKitExample \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```
