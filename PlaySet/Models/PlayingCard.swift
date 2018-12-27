//
//  PlayingSet.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/7/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCard: Hashable, CustomStringConvertible {
    var description: String { return "\(shape.rawValue) \(amount.rawValue) \(shading) \(color) \(cardState)" }
    
    private(set) var shape: Shape
    private(set) var amount: Amount
    private(set) var shading: Shading
    private(set) var color: Color
    var cardState: CardState
    
    enum Shape: String, CaseIterable {
        case triangle = "▲"
        case square = "■"
        case circle = "●"
    }
    
    enum Amount: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    
    enum Shading: String, CaseIterable {
        case filled
        case notFilled
        case faded // will be striped later
    }
    
    enum Color: String,  CaseIterable {
        case blue
        case red
        case green
    }
    
    enum CardState {
        case selected
        case notSelected
        case matched
    }
    
}

//extension TestEnum: Equatable {
//
//    public static func ==(lhs: TestEnum, rhs:TestEnum) -> Bool {
//
//        switch (lhs,rhs) {
//        case (.testB, .testB):
//            return true
//        case (.testA,.testA):
//            return true
//        default:
//            return false
//        }
//    }
//}

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
