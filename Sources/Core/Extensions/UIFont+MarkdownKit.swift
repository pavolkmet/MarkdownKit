//
//  UIFont+MarkdownKit.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import UIKit

public extension UIFont {
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        var newSymbolicTraits = fontDescriptor.symbolicTraits
        newSymbolicTraits.insert(traits)
        
        guard let descriptor = fontDescriptor.withSymbolicTraits(newSymbolicTraits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: weight)
    }
    
}
