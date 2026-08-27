import MarkdownKit
import SwiftUI

struct ContentView: View {

    // MARK: - Properties - Private

    private let elements = MarkdownElement.defaults + [
        .link(
            .appearance(
                MarkdownTextAppearance()
                    .foregroundStyle(.orange)
                    .font(.body.bold())
            )
        ),
        .custom(MarkdownExampleHashtagVisitor()),
    ]

    private let document = MarkdownDocument(
        parsing: """
        # MarkdownKit

        Render Markdown as a native SwiftUI `Text` view.

        Use **strong**, *emphasis*, and ~~strikethrough~~ with system styling.

        ## Links

        Open a [Markdown link](https://swift.org) or an unmarked link such as www.apple.com.

        ## Lists

        - A simple list item
        - A **formatted item**
          - A nested item

        1. First ordered item
        2. Second ordered item

        ## Custom visitors

        The example visitor adds app-owned links and styling to #Swift and #Markdown.
        """
    )

    // MARK: - View

    var body: some View {
        NavigationView {
            ScrollView {
                MarkdownText(document: document, elements: elements)
                    .markdownAppearance(.swiftUI)
                    .environment(\.openURL, OpenURLAction { url in
                        debugPrint(url)
                        return .handled
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
            }
            .navigationTitle("MarkdownKit")
        }
        .navigationViewStyle(.stack)
    }
}

#if DEBUG
// MARK: - Preview

#Preview {
    ContentView()
}
#endif
