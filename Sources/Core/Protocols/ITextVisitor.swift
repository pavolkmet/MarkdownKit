//
//  ITextVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol ITextVisitor {
    
    func visit(text: Text, result: inout NSMutableAttributedString, range: NSRange)
    
}
