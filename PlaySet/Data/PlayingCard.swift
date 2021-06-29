//
//  PlayingSet.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/7/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCard: Equatable, CustomStringConvertible {
    var description: String { return "\(shape.rawValue) \(amount.rawValue) \(shading) \(color) \(cardState)" }
    
    private(set) var shape: Shape
    private(set) var amount: Amount
    private(set) var shading: Shading
    private(set) var color: Color
    var cardState: CardState
    
    enum Shape: String, CaseIterable {
        case triangle
        case square
        case circle
    }
    
    enum Amount: Int, CaseIterable {
        case one
        case two
        case three
    }
    
    enum Shading: String, CaseIterable {
        case filled
        case notFilled
        case striped // will be striped later
    }
    
    enum Color: String,  CaseIterable {
        case blue
        case red
        case green
    }
    
    enum CardState {
        case selected
        case notSelected
    }
}
