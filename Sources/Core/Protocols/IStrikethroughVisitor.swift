//
//  IStrikethroughVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol IStrikethroughVisitor {
    
    func visit(strikethrough: Strikethrough, result: inout NSMutableAttributedString, range: NSRange)
    
}
