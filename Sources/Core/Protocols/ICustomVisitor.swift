//
//  ICustomVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol ICustomVisitor {
    
    func visit(text: Text, result: inout NSMutableAttributedString, range: NSRange) -> Bool
    
}
