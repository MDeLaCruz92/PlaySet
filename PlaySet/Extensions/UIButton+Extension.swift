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
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        layer.borderColor = UIColor.gray.cgColor
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 8.0
        layer.borderWidth = 3.0
    }
    
    func applyTouchSelectionUI() {
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.blue.cgColor
    }
    
    func applyTouchDeselectionUI() {
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.white.cgColor
    }
    
    func disableButton() {
        isEnabled = false
        alpha = 0.5
    }
    
    func enableButton() {
        isEnabled = true
        alpha = 1
    }
}

