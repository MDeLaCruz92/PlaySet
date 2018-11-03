//
//  UIView+Extension.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/7/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib(named: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
