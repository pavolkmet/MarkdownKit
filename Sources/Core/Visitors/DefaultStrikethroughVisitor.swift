//
//  DefaultStrikethroughVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultStrikethroughVisitor: IStrikethroughVisitor {
    
    // MARK: - Initialization - Public
    
    public init() { }
    
    // MARK: - IStrikethroughVisitor
    
    public func visit(strikethrough: Strikethrough, result: inout NSMutableAttributedString, range: NSRange) {
        result.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ], range: range)
    }
    
}
