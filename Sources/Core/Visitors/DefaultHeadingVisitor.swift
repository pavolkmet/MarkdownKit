//
//  DefaultHeadingVisitor.swift
//  MarkdownKit
//
//  Created by Pavol Kmet on 23/06/2023.
//

import Foundation

public struct DefaultHeadingVisitor: IHeadingVisitor {
    
    // MARK: - Level
    
    public struct Level {
        
        // MARK: - Properties - Public
        
        public let foregroundColor: UIColor
        public let font: UIFont
        
    }
    
    // MARK: - Properties - Public
    
    let levels: (
        one: Level,
        two: Level,
        three: Level,
        other: Level
    )
    
    // MARK: - Initialization - Public
    
    public init(levels: (one: Level, two: Level, three: Level, other: Level)) {
        self.levels = levels
    }
    
    public init() {
        self.init(
            levels: (
                one: Level(
                    foregroundColor: UIColor.label,
                    font: UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .semibold)
                ),
                two: Level(
                    foregroundColor: UIColor.label,
                    font: UIFont.preferredFont(forTextStyle: .title1).with(weight: .semibold)
                ),
                three: Level(
                    foregroundColor: UIColor.label,
                    font: UIFont.preferredFont(forTextStyle: .title2).with(weight: .semibold)
                ),
                other: Level(
                    foregroundColor: UIColor.label,
                    font: UIFont.preferredFont(forTextStyle: .title3).with(weight: .semibold)
                )
            )
        )
    }
    
    // MARK: - IHeadingVisitor
    
    public func visit(heading: Heading, result: inout NSMutableAttributedString, range: NSRange) {
        /// Attributes
        switch heading.level {
        case 1:
            result.addAttributes([
                .foregroundColor: levels.one.foregroundColor,
                .font: levels.one.font
            ], range: range)
        case 2:
            result.addAttributes([
                .foregroundColor: levels.two.foregroundColor,
                .font: levels.two.font
            ], range: range)
        case 3:
            result.addAttributes([
                .foregroundColor: levels.three.foregroundColor,
                .font: levels.two.font
            ], range: range)
        default:
            result.addAttributes([
                .foregroundColor: levels.other.foregroundColor,
                .font: levels.other.font
            ], range: range)
        }
        /// Newline
        if heading.hasSuccessor {
            result.append(NSAttributedString(
                string: "\n\n",
                attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body)
                ]
            ))
        }
    }
    
}
