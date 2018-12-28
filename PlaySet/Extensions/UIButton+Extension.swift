//
//  UIButton+Extension.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 11/6/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import UIKit

extension UIButton {
    func setupButtonUI() {
        self.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8.0
    }
    
    func applyTouchSelectionUI() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    func applyTouchDeselectionUI() {
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func disableButton() {
        self.isEnabled = false
        self.alpha = 0.5
    }
    
    func enableButton() {
        self.isEnabled = true
        self.alpha = 1
    }
}

