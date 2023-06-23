//
//  ListItemContainer+MarkdownKit.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

extension ListItemContainer {
    
    /// Depth of the list if nested within others. Index starts at 0.
    var listDepth: Int {
        var index = 0
        
        var element = parent
        
        while element != nil {
            if element is ListItemContainer {
                index += 1
            }
            element = element?.parent
        }
        
        return index
    }
    
}
