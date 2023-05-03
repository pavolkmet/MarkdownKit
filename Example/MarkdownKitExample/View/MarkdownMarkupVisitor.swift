//
//  MarkdownMarkupVisitor.swift
//  MarkdownKitExample
//
//  Created by Pavol Kmet on 03/05/2023.
//

import UIKit
import MarkdownKit

public struct MarkdownMarkupVisitor: MarkupVisitor {
    
    // MARK: - Appearance
    
    public struct Appearance {
        
        // MARK: - HeadingAppearance
        
        struct HeadingAppearance {
            
            let textColor: UIColor
            let font: UIFont
            
        }
        
        // MARK: - TextAppearance
        
        struct TextAppearance {
            
            let textColor: UIColor
            let font: UIFont
            
        }
        
        // MARK: - LinkAppearance
        
        struct LinkAppearance {
            
            let textColor: UIColor
            let font: UIFont
            
        }
        
        // MARK: - MentionAppearance
        
        struct MentionAppearance {
            
            let textColor: UIColor
            let font: UIFont
            
        }
        
        // MARK: - Properties - Public
        
        let heading: (
            one: HeadingAppearance,
            two: HeadingAppearance,
            three: HeadingAppearance,
            four: HeadingAppearance
        )
        let text: TextAppearance
        let link: LinkAppearance
        let mention: LinkAppearance
        let hashtag: LinkAppearance
        
        // MARK: - Computed Properties - Public
        
        public static var normal: Appearance {
            return .init(
                heading: (
                    one: .init(
                        textColor: UIColor.label,
                        font: UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .semibold) // 34.0
                    ),
                    two: .init(
                        textColor: UIColor.label,
                        font: UIFont.preferredFont(forTextStyle: .title1).with(weight: .semibold) // 28.0
                    ),
                    three: .init(
                        textColor: UIColor.label,
                        font: UIFont.preferredFont(forTextStyle: .title2).with(weight: .medium) // 22.0
                    ),
                    four: .init(
                        textColor: UIColor.label,
                        font: UIFont.preferredFont(forTextStyle: .title3).with(weight: .medium) // 20.0
                    )
                ),
                text: .init(
                    textColor: UIColor.label,
                    font: UIFont.preferredFont(forTextStyle: .body) // 17.0
                ),
                link: .init(
                    textColor: UIColor.orange,
                    font: UIFont.preferredFont(forTextStyle: .body).with(weight: .medium)
                ),
                mention: .init(
                    textColor: UIColor.red,
                    font: UIFont.preferredFont(forTextStyle: .body).with(weight: .semibold)
                ),
                hashtag: .init(
                    textColor: UIColor.red,
                    font: UIFont.preferredFont(forTextStyle: .body).with(weight: .semibold)
                )
            )
        }
        
    }
    
    let baseFontSize: CGFloat = 15.0
    
    // MARK: - Properties - Public
    
    public let appearance: Appearance
    
    // MARK: - Initialization - Public
    
    public init(appearance: Appearance = .normal) {
        self.appearance = appearance
    }
    
    // MARK: - Helper Methods - Public
    
    public mutating func attributedString(from document: Document) -> NSAttributedString {
        return visit(document)
    }
    
    // MARK: - MarkupVisitor
    
    public mutating func defaultVisit(_ markup: Markup) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in markup.children {
            result.append(visit(child))
        }
        
        return result
    }
    
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in blockQuote.children {
            var quoteAttributes: [NSAttributedString.Key: Any] = [:]
            
            let quoteParagraphStyle = NSMutableParagraphStyle()
            
            let baseLeftMargin: CGFloat = 15.0
            let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(blockQuote.quoteDepth))
            
            quoteParagraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: leftMarginOffset)]
            
            quoteParagraphStyle.headIndent = leftMarginOffset
            
            quoteAttributes[.paragraphStyle] = quoteParagraphStyle
            quoteAttributes[.font] = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
            quoteAttributes[.listDepth] = blockQuote.quoteDepth
            
            let quoteAttributedString = visit(child).mutableCopy() as! NSMutableAttributedString
            quoteAttributedString.insert(NSAttributedString(string: "\t", attributes: quoteAttributes), at: 0)
            
            quoteAttributedString.addAttribute(.foregroundColor, value: UIColor.systemGray)
            
            result.append(quoteAttributedString)
        }
        
        if blockQuote.hasSuccessor {
            result.append(visitDoubleNewline())
        }
        
        return result
    }
    
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> NSAttributedString {
        let result = NSMutableAttributedString(
            string: codeBlock.code,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: baseFontSize - 1.0, weight: .regular),
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        if codeBlock.hasSuccessor {
            result.append(visitSingleNewline())
        }
        
        return result
    }
    
    //    public mutating func visitCustomBlock(_ customBlock: CustomBlock) -> NSAttributedString {
    //        return defaultVisit(customBlock)
    //    }
    
    //    public mutating func visitDocument(_ document: Document) -> Result {
    //        return defaultVisit(document)
    //    }
    
    
    public mutating func visitHeading(_ heading: Heading) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in heading.children {
            result.append(visit(child))
        }

        switch heading.level {
        case 1:
            result.addAttributes([
                .foregroundColor: appearance.heading.one.textColor,
                .font: appearance.heading.one.font
            ], range: NSRange(location: 0, length: result.length))
        case 2:
            result.addAttributes([
                .foregroundColor: appearance.heading.two.textColor,
                .font: appearance.heading.two.font
            ], range: NSRange(location: 0, length: result.length))
        case 3:
            result.addAttributes([
                .foregroundColor: appearance.heading.three.textColor,
                .font: appearance.heading.three.font
            ], range: NSRange(location: 0, length: result.length))
        default:
            result.addAttributes([
                .foregroundColor: appearance.heading.four.textColor,
                .font: appearance.heading.four.font
            ], range: NSRange(location: 0, length: result.length))
        }
        
        if heading.hasSuccessor {
            result.append(visitDoubleNewline())
        }
        
        return result
    }
    
    //    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
    //        return defaultVisit(thematicBreak)
    //    }
    
    //    public mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
    //        return defaultVisit(html)
    //    }
    
//        public mutating func visitListItem(_ listItem: ListItem) -> Result {
//            return defaultVisit(listItem)
//        }
    
    mutating public func visitListItem(_ listItem: ListItem) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in listItem.children {
            result.append(visit(child))
        }
        
        if listItem.hasSuccessor {
            result.append(visitSingleNewline())
        }
        
        return result
    }
    
    mutating public func visitOrderedList(_ orderedList: OrderedList) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for (index, listItem) in orderedList.listItems.enumerated() {
            var listItemAttributes: [NSAttributedString.Key: Any] = [:]
            
            let font = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
            let numeralFont = UIFont.monospacedDigitSystemFont(ofSize: baseFontSize, weight: .regular)
            
            let listItemParagraphStyle = NSMutableParagraphStyle()
            
            // Implement a base amount to be spaced from the left side at all times to better visually differentiate it as a list
            
            let baseLeftMargin: CGFloat = 15.0
            let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(orderedList.listDepth))
            
            // Grab the highest number to be displayed and measure its width (yes normally some digits are wider than others but since we're using the numeral mono font all will be the same width in this case)
            let highestNumberInList = orderedList.childCount
            let numeralColumnWidth = ceil(NSAttributedString(string: "\(highestNumberInList).", attributes: [.font: numeralFont]).size().width)
            
            let spacingFromIndex: CGFloat = 8.0
            let firstTabLocation = leftMarginOffset + numeralColumnWidth
            let secondTabLocation = firstTabLocation + spacingFromIndex
            
            listItemParagraphStyle.tabStops = [
                NSTextTab(textAlignment: .right, location: firstTabLocation),
                NSTextTab(textAlignment: .left, location: secondTabLocation)
            ]
            
            listItemParagraphStyle.headIndent = secondTabLocation
            
            listItemAttributes[.paragraphStyle] = listItemParagraphStyle
            listItemAttributes[.font] = font
            listItemAttributes[.listDepth] = orderedList.listDepth
            
            let listItemAttributedString = visit(listItem).mutableCopy() as! NSMutableAttributedString
            
            // Same as the normal list attributes, but for prettiness in formatting we want to use the cool monospaced numeral font
            var numberAttributes = listItemAttributes
            numberAttributes[.font] = numeralFont
            
            let numberAttributedString = NSAttributedString(string: "\t\(index + 1).\t", attributes: numberAttributes)
            listItemAttributedString.insert(numberAttributedString, at: 0)
            
            result.append(listItemAttributedString)
        }
        
        if orderedList.hasSuccessor {
            result.append(orderedList.isContainedInList ? visitSingleNewline() : visitDoubleNewline())
        }
        
        return result
    }
    
    mutating public func visitUnorderedList(_ unorderedList: UnorderedList) -> NSAttributedString {
        //        return defaultVisit(unorderedList)
        
        let result = NSMutableAttributedString()
        
        let font = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
        
        for listItem in unorderedList.listItems {
            var listItemAttributes: [NSAttributedString.Key: Any] = [:]
            
            let listItemParagraphStyle = NSMutableParagraphStyle()
            
            let baseLeftMargin: CGFloat = 15.0
            let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(unorderedList.listDepth))
            let spacingFromIndex: CGFloat = 8.0
            let bulletWidth = ceil(NSAttributedString(string: "•", attributes: [.font: font]).size().width)
            let firstTabLocation = leftMarginOffset + bulletWidth
            let secondTabLocation = firstTabLocation + spacingFromIndex
            
            listItemParagraphStyle.tabStops = [
                NSTextTab(textAlignment: .right, location: firstTabLocation),
                NSTextTab(textAlignment: .left, location: secondTabLocation)
            ]
            
            listItemParagraphStyle.headIndent = secondTabLocation
            
            listItemAttributes[.paragraphStyle] = listItemParagraphStyle
            listItemAttributes[.font] = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
            listItemAttributes[.listDepth] = unorderedList.listDepth
            
            let listItemAttributedString = visit(listItem).mutableCopy() as! NSMutableAttributedString
            listItemAttributedString.insert(NSAttributedString(string: "\t•\t", attributes: listItemAttributes), at: 0)
            
            result.append(listItemAttributedString)
        }
        
        if unorderedList.hasSuccessor {
            result.append(visitDoubleNewline())
        }
        
        return result
    }
    
    public mutating func visitParagraph(_ paragraph: Paragraph) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in paragraph.children {
            result.append(visit(child))
        }
        
        if paragraph.hasSuccessor {
            if paragraph.isContainedInList {
                result.append(visitSingleNewline())
            } else {
                result.append(visitDoubleNewline())
            }
        }
        
        return result
    }
    
    //    public mutating func visitBlockDirective(_ blockDirective: BlockDirective) -> NSAttributedString {
    //        return defaultVisit(blockDirective)
    //    }
    
    public mutating func visitInlineCode(_ inlineCode: InlineCode) -> NSAttributedString {
        return NSAttributedString(
            string: inlineCode.code,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: baseFontSize - 1.0, weight: .regular),
                .foregroundColor: UIColor.systemGray
            ]
        )
    }
    
    public mutating func visitCustomInline(_ customInline: CustomInline) -> NSAttributedString {
        return defaultVisit(customInline)
    }
    
    mutating public func visitStrikethrough(_ strikethrough: Strikethrough) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strikethrough.children {
            result.append(visit(child))
        }
        
        result.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ], range: NSRange(location: 0, length: result.length))
//        result.addAttribute(
//            .strikethroughStyle,
//            value: NSUnderlineStyle.single.rawValue,
//            range: NSRange(location: 0, length: result.length)
//        )
        
        return result
    }
    
    public mutating func visitEmphasis(_ emphasis: Emphasis) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in emphasis.children {
            result.append(visit(child))
        }
        
        result.enumerateAttribute(.font, in: NSRange(location: 0, length: result.length), options: []) { value, range, _ in
            guard let font = value as? UIFont else {
                return
            }
            result.addAttribute(
                .font,
                value: font.with(traits: .traitItalic),
                range: range
            )
        }
        
        return result
    }
    
    //    public mutating func visitImage(_ image: Image) -> Result {
    //        return defaultVisit(image)
    //    }
    
    //    public mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Result {
    //        return defaultVisit(inlineHTML)
    //    }
    
    //    public mutating func visitLineBreak(_ lineBreak: LineBreak) -> NSAttributedString {
    //        return defaultVisit(lineBreak)
    //    }
    
    public mutating func visitLink(_ link: Link) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in link.children {
            result.append(visit(child))
        }
        
        if let destination = link.destination, let url = URL(string: destination) {
            result.addAttribute(
                .url,
                value: url,
                range: NSRange(location: 0, length: result.length)
            )
        }
        
        return result
    }
    
    //    public mutating func visitInlineAttributes(_ attributes: InlineAttributes) -> NSAttributedString {
    //        return defaultVisit(attributes)
    //    }
    //
    //    public mutating func visitSoftBreak(_ softBreak: SoftBreak) -> NSAttributedString {
    //        return defaultVisit(softBreak)
    //    }
    
    public mutating func visitStrong(_ strong: Strong) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strong.children {
            result.append(visit(child))
        }
        
        result.enumerateAttribute(.font, in: NSRange(location: 0, length: result.length), options: []) { value, range, _ in
            guard let font = value as? UIFont else {
                return
            }
            result.addAttribute(
                .font,
                value: font.with(traits: .traitBold),
                range: range
            )
        }
        
        return result
    }
    
    public mutating func visitText(_ text: Text) -> NSAttributedString {
        /// Parent is a `Link` if `true` continue if `false` it still might be a link but not markdown one.
        if text.parent is Link {
            if text.plainText.starts(with: "@") {
                return visitPlainMention(text)
            } else {
                return visitPlainLink(text)
            }
        } else {
            return visitUnmarkedLink(text)
        }
    }
    
    public mutating func visitUnmarkedLink(_ text: Text) -> NSAttributedString {
        /// No detector. In that case we cannot proceed. Fallback to the `visitPlainText`.
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return visitPlainText(text)
        }
        
        let range = NSRange(text.plainText.startIndex..<text.plainText.endIndex, in: text.plainText)
        let matches = detector.matches(in: text.plainText, options: [], range: range)
        
        /// No matches. In that case there are definitely no links. Fallback to the `visitPlainText`.
        guard matches.isEmpty == false else {
            return visitPlainText(text)
        }
        
        let result = NSMutableAttributedString(attributedString: visitPlainText(text))
        
        for match in matches {
            /// No url. In that case there is no link. Fallback to the `visitPlainText`.
            guard let url = match.url else {
                return visitPlainText(text)
            }
            /// Add the `url` link attributes.
            result.addAttributes([
                .foregroundColor: appearance.link.textColor,
                .font: appearance.link.font,
                .url: url
            ], range: match.range)
        }
        
        return result
    }
    
    public func visitPlainMention(_ text: Text) -> NSAttributedString {
        return NSAttributedString(
            string: text.plainText,
            attributes: [
                .foregroundColor: appearance.mention.textColor,
                .font: appearance.mention.font
            ]
        )
    }
    
    public func visitPlainLink(_ text: Text, range: NSRange? = nil) -> NSAttributedString {
        return NSAttributedString(
            string: text.plainText,
            attributes: [
                .foregroundColor: appearance.link.textColor,
                .font: appearance.link.font
            ]
        )
    }
    
    public func visitPlainText(_ text: Text) -> NSAttributedString {
        return NSAttributedString(
            string: text.plainText,
            attributes: [
                .foregroundColor: appearance.text.textColor,
                .font: appearance.text.font
            ]
        )
    }
    
    public func visitSingleNewline() -> NSAttributedString {
        return NSAttributedString(
            string: "\n",
            attributes: [
                .font: appearance.text.font
            ]
        )
    }
    
    public func visitDoubleNewline() -> NSAttributedString {
        return NSAttributedString(
            string: "\n\n",
            attributes: [
                .font: appearance.text.font
            ]
        )
    }
    
}


// MARK: - Extensions Land

extension NSMutableAttributedString {

    
    func applyLink(withURL url: URL?) {
        addAttribute(.foregroundColor, value: UIColor.systemBlue)
        
        if let url = url {
            addAttribute(.attachment, value: url)
        }
    }
    
    func applyBlockquote() {
        addAttribute(.foregroundColor, value: UIColor.systemGray)
    }
    
    func applyStrikethrough() {
        addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
    }
}

extension UIFont {
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        var newSymbolicTraits = fontDescriptor.symbolicTraits
        newSymbolicTraits.insert(traits)
        
        guard let descriptor = fontDescriptor.withSymbolicTraits(newSymbolicTraits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: weight)
    }
    
    func apply(newTraits: UIFontDescriptor.SymbolicTraits, newPointSize: CGFloat? = nil) -> UIFont {
        var traits = fontDescriptor.symbolicTraits
        traits.insert(newTraits)
        
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: newPointSize ?? pointSize)
    }
    
}

extension ListItemContainer {
    /// Depth of the list if nested within others. Index starts at 0.
    var listDepth: Int {
        var index = 0
        
        var currentElement = parent
        
        while currentElement != nil {
            if currentElement is ListItemContainer {
                index += 1
            }
            
            currentElement = currentElement?.parent
        }
        
        return index
    }
}

extension BlockQuote {
    /// Depth of the quote if nested within others. Index starts at 0.
    var quoteDepth: Int {
        var index = 0
        
        var currentElement = parent
        
        while currentElement != nil {
            if currentElement is BlockQuote {
                index += 1
            }
            
            currentElement = currentElement?.parent
        }
        
        return index
    }
}

extension NSAttributedString.Key {
    static let listDepth = NSAttributedString.Key("ListDepth")
    static let quoteDepth = NSAttributedString.Key("QuoteDepth")
    static let url = NSAttributedString.Key("URL")
}

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: NSRange(location: 0, length: length))
    }
    
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        addAttributes(attrs, range: NSRange(location: 0, length: length))
    }
}

extension Markup {
    /// Returns true if this element has sibling elements after it.
    var hasSuccessor: Bool {
        guard let childCount = parent?.childCount else { return false }
        return indexInParent < childCount - 1
    }
    
    var isContainedInList: Bool {
        var currentElement = parent
        
        while currentElement != nil {
            if currentElement is ListItemContainer {
                return true
            }
            
            currentElement = currentElement?.parent
        }
        
        return false
    }
}
