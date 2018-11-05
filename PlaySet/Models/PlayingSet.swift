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
    
    enum Shape  {
        case triangle
        case circle
        case square
    }
    
    
}

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
