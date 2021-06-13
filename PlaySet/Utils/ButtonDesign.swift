//
//  ButtonDesign.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 9/26/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import UIKit

extension UIButton {
    func setupCardButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        return button
    }
}
