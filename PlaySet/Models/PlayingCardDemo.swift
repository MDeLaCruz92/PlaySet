//
//  File.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/6/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

/** Stanford Lecture 5 */

import Foundation

struct PlayingCardDemo: CustomStringConvertible {
    var description: String { return "\(rank)\(suit)" }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case hearts = "♥️"
        case spades = "♠️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all = [Suit.spades,hearts,diamonds,clubs]
        
        var description: String { return rawValue }
    }
    
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int? {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return nil
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"),face("Q"),face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
}
