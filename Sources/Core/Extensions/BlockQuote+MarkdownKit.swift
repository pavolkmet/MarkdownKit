//
//  BlockQuote+MarkdownKit.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

extension BlockQuote {
    
    /// Depth of the quote if nested within others. Index starts at 0.
    var quoteDepth: Int {
        var index = 0
        
        var element = parent
        
        while element != nil {
            if element is BlockQuote {
                index += 1
            }
            element = element?.parent
        }
        
        return index
    }

}
