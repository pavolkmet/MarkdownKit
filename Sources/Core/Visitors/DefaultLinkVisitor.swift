//
//  DefaultLinkVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultLinkVisitor: ILinkVisitor {
    
    // MARK: - Properties - Public
    
    public let foregroundColor: UIColor
    public let font: UIFont
    
    // MARK: - Initialization - Public
    
    public init(foregroundColor: UIColor, font: UIFont) {
        self.foregroundColor = foregroundColor
        self.font = font
    }
    
    public init() {
        self.foregroundColor = UIColor.tintColor
        self.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .medium)
    }
    
    // MARK: - ILinkVisitor
    
    public func visit(link: Link, result: inout NSMutableAttributedString, range: NSRange) {
        if let destination = link.destination {
            result.addAttributes([
                .foregroundColor: foregroundColor,
                .font: font,
                .url: URL(string: destination) ?? NSNull()
            ], range: range)
        }
    }
    
}
