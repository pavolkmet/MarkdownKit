//
//  Markup+MarkdownKit.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

extension Markup {
    
    /// Returns true if this element has sibling elements after it.
    var hasSuccessor: Bool {
        guard let childCount = parent?.childCount else {
            return false
        }
        return indexInParent < childCount - 1
    }
    
    var isContainedInList: Bool {
        var element = parent
        
        while element != nil {
            if element is ListItemContainer {
                return true
            }
            element = element?.parent
        }
        
        return false
    }
    
}
