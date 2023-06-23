//
//  DefaultUnmarkedLinksVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultUnmarkedLinksVisitor: ICustomVisitor {
    
    // MARK: - Properties - Public
    
    public let foregroundColor: UIColor
    public let font: UIFont
    public let detector: NSDataDetector?
    
    // MARK: - Initialization - Public
    
    public init(foregroundColor: UIColor, font: UIFont, detector: NSDataDetector?) {
        self.foregroundColor = foregroundColor
        self.font = font
        self.detector = detector
    }
    
    public init(foregroundColor: UIColor, font: UIFont) {
        self.init(
            foregroundColor: foregroundColor,
            font: font,
            detector: try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        )
        
    }
    
    public init() {
        self.init(
            foregroundColor: UIColor.tintColor,
            font: UIFont.preferredFont(forTextStyle: .body).with(weight: .medium)
        )
    }
    
    // MARK: - ICustomVisitor
    
    public func visit(text: Text, result: inout NSMutableAttributedString, range: NSRange) -> Bool {
        /// 1️⃣ Check if `detector` is in place.
        guard let detector = detector else {
            return false
        }
        /// 2️⃣ Process `matches` within the `text.plainText`.
        let matches = detector.matches(
            in: text.plainText,
            options: [],
            range: NSRange(text.plainText.startIndex..<text.plainText.endIndex, in: text.plainText)
        )
        /// 3️⃣ Check if there are any `matches`.
        guard matches.isEmpty == false else {
            return false
        }
        for match in matches {
            /// 4️⃣ Check if there is an `url`.
            guard let url = match.url else {
                continue
            }
            /// 5️⃣ Update appearance of the `result`.
            result.addAttributes([
                .foregroundColor: foregroundColor,
                .font: font,
                .url: url
            ], range: match.range)
        }
        return true
    }
    
}
