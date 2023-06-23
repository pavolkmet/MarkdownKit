//
//  MarkdownKitMarkupVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 03/05/2023.
//

import UIKit

public struct MarkdownMarkupVisitor: MarkupVisitor {
    
    // MARK: - Visitors
    
    public struct Visitors {
        
        // MARK: - Properties - Public
        
        let heading: IHeadingVisitor
        let link: ILinkVisitor
        let text: ITextVisitor
        let strikethrough: IStrikethroughVisitor
        let emphasis: IEmphasisVisitor
        let strong: IStrongVisitor
        let custom: [ICustomVisitor]
        
        // MARK: - Initialization - Public
        
        public init(
            heading: IHeadingVisitor = DefaultHeadingVisitor(),
            link: ILinkVisitor = DefaultLinkVisitor(),
            text: ITextVisitor = DefaultTextVisitor(),
            strikethrough: IStrikethroughVisitor = DefaultStrikethroughVisitor(),
            emphasis: IEmphasisVisitor = DefaultEmphasisVisitor(),
            strong: IStrongVisitor = DefaultStrongVisitor(),
            custom: [ICustomVisitor] = [DefaultHashtagVisitor(), DefaultMentionVisitor(), DefaultUnmarkedLinksVisitor()]
        ) {
            self.heading = heading
            self.link = link
            self.text = text
            self.strikethrough = strikethrough
            self.emphasis = emphasis
            self.strong = strong
            self.custom = custom
        }
        
    }
    
    let baseFontSize: CGFloat = 15.0
    
    // MARK: - Properties - Public
    
    public let visitors: Visitors
    
    // MARK: - Initialization - Public
    
    public init(visitors: Visitors = .init()) {
        self.visitors = visitors
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
            
            quoteAttributedString.addAttribute(.foregroundColor, value: UIColor.systemGray, range: NSRange(location: 0, length: quoteAttributedString.length))
            
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
        var result = NSMutableAttributedString()
        
        for child in heading.children {
            result.append(visit(child))
        }

        visitors.heading.visit(heading: heading, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
//        public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
//            return defaultVisit(thematicBreak)
//        }
    
//        public mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
//            return defaultVisit(html)
//        }
    
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
        var result = NSMutableAttributedString()
        
        for child in strikethrough.children {
            result.append(visit(child))
        }
        
        visitors.strikethrough.visit(strikethrough: strikethrough, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
    public mutating func visitEmphasis(_ emphasis: Emphasis) -> NSAttributedString {
        var result = NSMutableAttributedString()
        
        for child in emphasis.children {
            result.append(visit(child))
        }
        
        visitors.emphasis.visit(emphasis: emphasis, result: &result, range: NSRange(location: 0, length: result.length))
        
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
        var result = NSMutableAttributedString()
        
        for child in strong.children {
            result.append(visit(child))
        }
        
        visitors.strong.visit(strong: strong, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
    public mutating func visitText(_ text: Text) -> NSAttributedString {
        var result = NSMutableAttributedString(attributedString: visitPlainText(text))

        var shouldUseResult = false
        for custom in visitors.custom {
            let visited = custom.visit(text: text, result: &result, range: NSRange(location: 0, length: result.length))
            if visited {
                shouldUseResult = true
            }
        }

        if shouldUseResult {
            return result
        } else {
            if text.parent is Link {
                return visitPlainLink(text)
            } else {
                return visitPlainText(text)
            }
        }
    }
    
    public func visitPlainLink(_ text: Text, range: NSRange? = nil) -> NSAttributedString {
        var result = NSMutableAttributedString(string: text.plainText)
        
        visitors.link.visit(link: Link(destination: text.plainText, []), result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
    public func visitPlainText(_ text: Text) -> NSAttributedString {
        var result = NSMutableAttributedString(string: text.plainText)
        
        visitors.text.visit(text: text, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
    public func visitSingleNewline() -> NSAttributedString {
        let text = Text("\n")
        var result = NSMutableAttributedString(string: text.plainText)
        
        visitors.text.visit(text: text, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
    public func visitDoubleNewline() -> NSAttributedString {
        let text = Text("\n\n")
        var result = NSMutableAttributedString(string: text.plainText)
        
        visitors.text.visit(text: text, result: &result, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
}
