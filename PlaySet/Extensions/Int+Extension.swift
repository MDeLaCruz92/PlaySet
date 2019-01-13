//
//  Int+Extension.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 1/13/19.
//  Copyright © 2019 Michael De La Cruz. All rights reserved.
//

import Foundation

extension  Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
