//
//  DefaultTextVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultTextVisitor: ITextVisitor {
    
    // MARK: - Properties - Public
    
    public let foregroundColor: UIColor
    public let font: UIFont
    
    // MARK: - Initialization - Public
    
    public init(foregroundColor: UIColor = UIColor.label, font: UIFont = UIFont.preferredFont(forTextStyle: .body)) {
        self.foregroundColor = foregroundColor
        self.font = font
    }
    
    // MARK: - ITextVisitor
    
    public func visit(text: Text, result: inout NSMutableAttributedString, range: NSRange) {
        result.addAttributes([
            .foregroundColor: foregroundColor,
            .font: font
        ], range: range)
    }
    
}
