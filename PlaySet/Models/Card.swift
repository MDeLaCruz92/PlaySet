//
//  Card.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 9/28/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    private var identifier: Int
    
    var hashable: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return Card.identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
