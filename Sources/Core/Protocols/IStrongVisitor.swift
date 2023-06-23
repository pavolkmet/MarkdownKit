//
//  IStrongVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol IStrongVisitor {
    
    func visit(strong: Strong, result: inout NSMutableAttributedString, range: NSRange)
    
}
