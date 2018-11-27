//
//  PlayingSet.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/7/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCard: Hashable, CustomStringConvertible {
    var description: String { return "\(shape) \(amount) \(shading) \(color) \(cardState)" }
    
    private(set) var shape: Shape
    private(set) var amount: Amount
    private(set) var shading: Shading
    private(set) var color: Color
    var cardState: CardState
    
    enum Shape: Equatable, CaseIterable {
        case triangle
        case square
        case circle
    }
    
    enum Amount: Equatable, CaseIterable {
        case one
        case two
        case three
    }
    
    enum Shading:  Equatable, CaseIterable {
        case filled
        case notFilled
        case striped
    }
    
    enum Color: Equatable, CaseIterable {
        case blue
        case red
        case green
    }
    
    enum CardState: Equatable {
        case matched
        case noMatch
        case selected
        case notSelected
    }
    
}

//var order: Int? {
//    switch self {
//    case .ace: return 1
//    case .numeric(let pips): return pips
//    case .face(let kind) where kind == "J": return 11
//    case .face(let kind) where kind == "Q": return 12
//    case .face(let kind) where kind == "K": return 13
//    default: return nil
//    }
//}


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
