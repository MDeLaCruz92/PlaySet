//
//  PlayingSet.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/7/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

// MARK: This can be determined as PlayingCard
struct PlayingSet: Hashable {
    
    private var identifier: Int
    
    var hashable: Int { return identifier }
    
    static func ==(lhs: PlayingSet, rhs: PlayingSet) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return PlayingSet.identifierFactory
    }
    
    init() {
        self.identifier = PlayingSet.getUniqueIdentifier()
    }
    
    enum Shape {
        case triangle
        case square
        case circle
    }
    
    enum Amount: Int {
        case one = 1
        case two
        case three
    }
    
    enum Shading {
        case filled
        case notFilled
        case striped
    }
    
    enum Color {
        case blue
        case red
        case green
    }
}


/*
 - How am I going to get them matching? As in the features should be implemented in the card? And then, match them ??
 - 
 */

/*
 What is a SET?
 
 A SET is three cards where each feature, when looked at individually, is either all the same OR all different. Each card contains four features: color
 (red, purple or green), shape (oval, squiggle or diamond), number (one, two or three) and shading (solid, striped or outlined).
 */

/*
 Set Game:
-  Has a list of cards that are being played
 - It has some selected cards
 - It knows whether the currently selected cards are a match or not
-  It has a deck of cards from which it is dealing
 - It probably wants to keep track of which cards have already been matched
 */

/*
 It’d probably good MVC design not to hardwire specific color names or shape names
 (like diamond or oval or green or striped) into the property names in your Model code.
 As you can see with this assignment (where we’re using ▲●■ instead of the standard
 shapes and shading instead of striping, etc.), the colors, shapes, etc., are really a UI
 concept and have nothing to do with the Model.
 */

/*
enum Symbol: CaseIterable {
    case triangle
    case circle
    case square
    
    case red
    case blue
    case green
    
    case stripe
    case notFilled
    case filled
    
    case single
    case double
    case triple
}
*/
