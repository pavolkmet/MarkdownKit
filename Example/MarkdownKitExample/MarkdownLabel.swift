//
//  MarkdownLabel.swift
//  MarkdownKitExample
//
//  Created by Pavol Kmet on 03/05/2023.
//

import UIKit
import Combine

final class MarkdownLabel: UILabel {
    
    // MARK: - Event
    
    enum Event: Equatable {
        
        case onURL(URL)
        
    }
    
    // MARK: - Properties - Private
    
    private let event = PassthroughSubject<Event, Never>()
    
    private var layoutManager: NSLayoutManager!
    private var textContainer: NSTextContainer!
    private var textStorage: NSTextStorage!
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Override
    
    override var bounds: CGRect {
        didSet {
            configureManagers()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            configureManagers()
        }
    }
    
    override var lineBreakMode: NSLineBreakMode {
        didSet {
            configureManagers()
        }
    }
    
    override var numberOfLines: Int {
        didSet {
            configureManagers()
        }
    }
    
    // MARK: - Initialization - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bindSubscriptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled else {
            return super.hitTest(point, with: event)
        }
        debugPrint(#function, point)
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        /// Ensure the glyphIndex actually matches the point and isn't just the closest glyph to the point
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: textContainer)
        
        guard glyphIndex < textStorage.length else {
            return super.hitTest(point, with: event)
        }
        guard glyphRect.contains(point) else {
            return super.hitTest(point, with: event)
        }
        guard let value = textStorage.attribute(.link, at: glyphIndex, effectiveRange: nil) as? URL ??
                          textStorage.attribute(.url, at: glyphIndex, effectiveRange: nil) as? URL else {
            return super.hitTest(point, with: event)
        }
        self.event.send(.onURL(value))
        return self
    }
    
    // MARK: - Combine - Private
    
    private func bindSubscriptions() {
        event
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { event in
                debugPrint(#function, event)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Configure - Private
    
    private func configureManagers() {
        layoutManager = NSLayoutManager()
        textContainer = NSTextContainer(size: bounds.size)
        textStorage = NSTextStorage()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.size = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines).size
        textStorage.setAttributedString(attributedText ?? NSAttributedString())
    }
    
}
