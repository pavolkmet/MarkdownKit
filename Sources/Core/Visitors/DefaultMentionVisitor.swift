//
//  DefaultMentionVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultMentionVisitor: ICustomVisitor {
    
    // MARK: - Properties - Public
    
    public let foregroundColor: UIColor
    public let font: UIFont
    public let regex: NSRegularExpression?
    
    // MARK: - Initialization - Public
    
    public init(foregroundColor: UIColor, font: UIFont, regex: NSRegularExpression?) {
        self.foregroundColor = foregroundColor
        self.font = font
        self.regex = regex
    }
    
    public init(foregroundColor: UIColor, font: UIFont) {
        self.init(
            foregroundColor: foregroundColor,
            font: font,
            regex: try? NSRegularExpression(pattern: #"\B@(\w+)"#)
        )
        
    }
    
    public init() {
        self.init(
            foregroundColor: UIColor.tintColor,
            font: UIFont.preferredFont(forTextStyle: .body).with(weight: .semibold)
        )
    }
    
    // MARK: - ICustomVisitor
    
    public func visit(text: Text, result: inout NSMutableAttributedString, range: NSRange) -> Bool {
        if text.parent is Link {
            
            guard text.plainText.starts(with: "@") else {
                return false
            }
            result.addAttributes([
                .foregroundColor: foregroundColor,
                .font: font
            ], range: range)
            return true
            
        } else {
            
            guard let regex = regex else {
                return false
            }
            let matches = regex.matches(
                in: text.plainText,
                range: NSRange(text.plainText.startIndex..<text.plainText.endIndex, in: text.plainText)
            )
            guard matches.isEmpty == false else {
                return false
            }
            for match in matches {
                if let range = Range(match.range(at: 0), in: result.string) {
                    result.addAttributes([
                        .foregroundColor: foregroundColor,
                        .font: font,
                        .url: URL(string: "/mention/\(result.string[range])") ?? NSNull()
                    ], range: match.range)
                }
            }
            return true
            
        }
    }
    
}
