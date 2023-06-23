//
//  IEmphasisVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol IEmphasisVisitor {
    
    func visit(emphasis: Emphasis, result: inout NSMutableAttributedString, range: NSRange)
    
}
