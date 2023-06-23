//
//  ContentView.swift
//  MarkdownKitExample
//
//  Created by Pavol Kmet on 03/05/2023.
//

import SwiftUI
import MarkdownKit

let markdown = """
### Korean

[+420](/number/420)

### English

This is a mention which is not clickable as there is no markdown link @username something🤷‍♂️ and this a deeplink [@username](spaces://username) or unmarked link like *https://link.com* or strikethrough ~https://hornet.com/support?yessir~ or pavol.kmet@hornet.com fds fds .

What about a hashtag? Sure we have a support for makrdown one like [#something](/search/something) and also unmarked one like #PF2023. Yay

Opening paragraph, with an ordered list of autumn leaves I found

1. A big leaf
1. Some small leaves:
    1. Red (nested)
    2. **Orange**
    3. Yellow
1. A medium sized leaf that ~~maybe~~ was pancake shaped

Unordered list of fruits:

- Blueberries
- Apples
    - Macintosh
    - Honey crisp
    - Cortland
- Banana

# Header One
## Header Two
### Header Three
#### Header Four

Here's what someone said:

> I think blockquotes are cool

Nesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!

And then they mentiond code around `NSAttributedString` that looked like this code block:

```swift
func yeah() -> NSAttributedString {
    // TODO: Write code
}
```

Tables are even supported but (but need more than `NSAttributedString`  for support :p)

Opening paragraph, with an ordered list of autumn leaves I found

1. A big leaf
1. Some small leaves:
    1. Red (nested)
    2. **Orange**
    3. Yellow
1. A medium sized leaf that ~~maybe~~ was pancake shaped

Unordered list of fruits:

- Blueberries
- Apples
    - Macintosh
    - Honey crisp
    - Cortland
- Banana

### Fancy Header Title

Here's what someone said:

> I think blockquotes are cool

Nesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!

And then they mentiond code around `NSAttributedString` that looked like this code block:

```swift
func yeah() -> NSAttributedString {
    // TODO: Write code
}
```

Tables are even supported but (but need more than `NSAttributedString` for support :p)

Opening paragraph, with an ordered list of autumn leaves I found

1. A big leaf
1. Some small leaves:
    1. Red (nested)
    2. **Orange**
    3. Yellow
1. A medium sized leaf that ~~maybe~~ was pancake shaped

Unordered list of fruits:

- Blueberries
- Apples
    - Macintosh
    - Honey crisp
    - Cortland
- Banana

### Fancy Header Title

Here's what someone said:

> I think blockquotes are cool

Nesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!

And then they mentiond code around `NSAttributedString` that looked like this code block:

```swift
func yeah() -> NSAttributedString {
    // TODO: Write code
}
```

Tables are even supported but (but need more than `NSAttributedString` for support :p)

### Japanese

マークダウンリンク @username something🤷‍♂️ と、これはディープリンク [@username](spaces://username) や *https://link.com* や取り消し線 ~https://hornet.com/support?yessir~ のようなマークのないリンクがないため、クリックできない言及といえます。

ハッシュタグはどうでしょうか？もちろん、[#something](/search/something)のようなmakrdownのものや、#PF2023のようなunmarkedのものもサポートされていますよ。そうですね。

冒頭、私が見つけた紅葉を順番に並べながら

1. 大きな葉っぱ
1. 小さな葉っぱもあります：
    1. 赤（入れ子）
    2. **オレンジ**色
    3. 黄色
1. 中くらいの大きさの葉っぱで、～～かもしれない～～パンケーキの形をしていた。

果物の順序なしリスト：

- ブルーベリー
- りんご
    - マッキントッシュ
    - ハニークリスプ
    - コートランド
- バナナ

# ヘッダーワン
## ヘッダー2
### ヘッダー3
#### ヘッダー4

ある人の言葉を紹介します：

> ブロッククオートはクールだと思う

強いテキストの中に **an *[強調リンク](https://apolloapp.io)* を入れ子にする**、素敵ですね！

そして、彼らは `NSAttributedString` の周りのコードに言及し、それは次のコードブロックのように見えた：

```swift
func yeah() -> NSAttributedString {
    // TODO: コードを書く
}
```

テーブルもサポートされていますが、（ただし、サポートには `NSAttributedString` 以外のものが必要です :p)

冒頭の、紅葉を並べたリストは、私が見つけたものです。

1. 大きな葉っぱ
1. 小さな葉っぱもあります：
    1. 赤（入れ子）
    2. **オレンジ**色
    3. 黄色
1. 中くらいの大きさの葉っぱで、～～かもしれない～～パンケーキの形をしていた。

果物の順序なしリスト：

- ブルーベリー
- りんご
    - マッキントッシュ
    - ハニークリスプ
    - コートランド
- バナナ

### ファンシーヘッダータイトル

ある人の言葉を紹介します：

> ブロッククオートはクールだと思う

強いテキストの中に **an *[強調リンク](https://apolloapp.io)* を入れ子にする**、素敵ですね！

そして、彼らは `NSAttributedString` の周りのコードに言及し、それは次のコードブロックのように見えました：

```swift
func yeah() -> NSAttributedString {
    // TODO: コードを書く
}
```

テーブルもサポートされていますが（ただし、サポートには `NSAttributedString` 以外のものが必要です :p)

"""

struct UIKitLabel: UIViewRepresentable {
    
    @Binding var text: NSAttributedString

    func makeUIView(context: Context) -> UILabel {
        let label = MarkdownLabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = text
    }
    
}

struct ContentView: View {
    var body: some View {
        let document = Document(parsing: markdown)
        var markupVisitor = MarkdownMarkupVisitor()
        let value = markupVisitor.attributedString(from: document)
        let text = AttributedString(value)
        ScrollView {
            UIKitLabel(text: .constant(value))
//            SwiftUI.Text(text)
                .environment(\.openURL, OpenURLAction { url in
                    debugPrint(url)
                    return .handled
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
