//
//  KeyView.swift
//  BPMCalculator
//
//  Created by Michael Crawford on 5/21/25.
//  Copyright © 2025 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

final class KeyView: UIView {
    
    private var keypressDetected: ((AnyObject) -> Void)?
    
    init(with keypressDetected: ((AnyObject) -> Void)? = nil) {
        super.init(frame: .zero)
        self.keypressDetected = keypressDetected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        keypressDetected?(self)
    }
    
    #if false // Don't need it right now.
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
    }
    #endif
}

