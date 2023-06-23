//
//  ILinkVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public protocol ILinkVisitor {
    
    func visit(link: Link, result: inout NSMutableAttributedString, range: NSRange)
    
}
