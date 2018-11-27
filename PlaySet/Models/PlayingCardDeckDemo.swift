//
//  PlayingCardDeck.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/6/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCardDeckDemo {
    private(set) var cards = [PlayingCardDemo]()
    
    init() {
        for suit in PlayingCardDemo.Suit.all {
            for rank in PlayingCardDemo.Rank.all {
                cards.append(PlayingCardDemo(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCardDemo? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

extension Int {
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
