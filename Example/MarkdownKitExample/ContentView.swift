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

이 멘션은 @사용자 아이디 something🤷‍♂️ 라는 마크다운 링크가 없고 [@사용자 아이디](스페이스://사용자 아이디) 또는 *https://link.com* 또는 취소선 ~https://hornet.com/support?yessir~과 같은 마크가 없는 링크이므로 클릭할 수 없는 멘션입니다.

해시태그는 어떻게 하나요? 물론 [#something](/search/something)과 같은 마크다운 해시태그와 #PF2023과 같은 마크가 없는 해시태그도 지원됩니다. Yay

내가 찾은 단풍의 목록을 순서대로 나열한 첫 문단

1. 큰 나뭇잎
1. 작은 나뭇잎 몇 개
    1. 빨간색(중첩)
    2. **주황색** 2.
    3. 노란색
1. 팬케이크 모양인 ~~아마~~ 중간 크기의 잎

주문되지 않은 과일 목록:

- 블루베리
- 사과
    - 매킨토시
    - 허니 크리스프
    - 코틀랜드
- 바나나

# 헤더 1
## 헤더 2
### 헤더 3
#### 헤더 4

누군가 이렇게 말했습니다:

> 블록 따옴표가 멋지다고 생각해요

강한 텍스트** 안에 *[강조 링크](https://apolloapp.io)*를 중첩하면 멋지죠!

그리고 그들은 이 코드 블록처럼 보이는 `NSAttributedString` 주위의 코드를 언급했습니다:

```swift
func yeah() -> NSAttributedString {
    // TODO: 코드 작성
}
```

테이블도 지원되지만 (하지만 지원을 위해서는 `NSAttributedString` 이상이 필요합니다 :p).

내가 찾은 단풍의 순서대로 나열된 단락을 여는 문단

1. 큰 잎
1. 작은 나뭇잎 몇 개
    1. 빨간색(중첩)
    2. **주황색**
    3. 노란색
1. 팬케이크 모양인 ~~아마~~ 중간 크기의 잎

주문되지 않은 과일 목록:

- 블루베리
- 사과
    - 매킨토시
    - 허니 크리스프
    - 코틀랜드
- 바나나

### 멋진 헤더 제목

누군가 이렇게 말했습니다:

> 블록 따옴표가 멋지다고 생각해요

강한 텍스트** 안에 *[강조 링크](https://apolloapp.io)*를 중첩하는 것, 멋지네요!

그리고 그들은 이 코드 블록처럼 보이는 `NSAttributedString` 주위의 코드를 언급했습니다:

```swift
func yeah() -> NSAttributedString {
    // TODO: 코드 작성
}
```

테이블도 지원되지만 (하지만 지원을 위해서는 `NSAttributedString` 이상이 필요합니다 :p).

내가 찾은 단풍의 순서대로 나열된 단락을 여는 문단

1. 큰 잎
1. 작은 나뭇잎 몇 개
    1. 빨간색(중첩)
    2. **주황색**
    3. 노란색
1. 팬케이크 모양인 ~~아마~~ 중간 크기의 잎

주문되지 않은 과일 목록:

- 블루베리
- 사과
    - 매킨토시
    - 허니 크리스프
    - 코틀랜드
- 바나나

### 멋진 헤더 제목

누군가 이렇게 말했습니다:

> 블록 따옴표가 멋지다고 생각해요

강한 텍스트** 안에 *[강조 링크](https://apolloapp.io)*를 중첩하는 것, 멋지네요!

그리고 그들은 이 코드 블록처럼 보이는 `NSAttributedString` 주위의 코드를 언급했습니다:

```swift
func yeah() -> NSAttributedString {
    // TODO: 코드 작성
}
```

테이블도 지원되지만 (하지만 지원을 위해서는 `NSAttributedString` 이상이 필요 :p)

### English

This is a mention which is not clickable as there is no markdown link @username something🤷‍♂️ and this a deeplink [@username](spaces://username) or unmarked link like *https://link.com* or strikethrough ~https://hornet.com/support?yessir~.

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
        var markupVisitor = MarkdownMarkupVisitor(appearance: .normal)
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
