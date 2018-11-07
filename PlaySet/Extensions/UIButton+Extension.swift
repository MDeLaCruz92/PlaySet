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
}
