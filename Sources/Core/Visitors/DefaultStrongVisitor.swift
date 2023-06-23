//
//  DefaultStrongVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultStrongVisitor: IStrongVisitor {
    
    // MARK: - Properties - Public
    
    public let traits: UIFontDescriptor.SymbolicTraits
    
    // MARK: - Initialization - Public
    
    public init(traits: UIFontDescriptor.SymbolicTraits = .traitBold) {
        self.traits = traits
    }
    
    // MARK: - IStrongVisitor
    
    public func visit(strong: Strong, result: inout NSMutableAttributedString, range: NSRange) {
        result.enumerateAttribute(.font, in: range, options: []) { value, range, _ in
            guard let font = value as? UIFont else {
                return
            }
            result.addAttribute(
                .font,
                value: font.with(traits: traits),
                range: range
            )
        }
    }
    
}
