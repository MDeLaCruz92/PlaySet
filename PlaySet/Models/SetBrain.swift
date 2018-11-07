//
//  SetBrain.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 11/2/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

// MARK: This can be PlayingCardDeck
struct SetBrain {
    
    private(set) var setCards = [PlayingSet]()
    private(set) var selectedCards = [Int]()

    static let matchPoints = 2
    static let misMatchPenalty = 1
    
    private let selectionLimit = 3
    
    mutating func chooseCard(at index: Int)  {
        // check if cards match
        // select 3 cards and then check if they are a match
        // how can we do this? maybe we need the equatable(like int and strings do) but also need a enum to verify if they are the same??
        if selectedCards.count < selectionLimit {
            selectedCards.append(index)
        }
        print("selectedCards: \(selectedCards)")

        if selectedCards.count == 3 {
            selectedCards = [Int]()
        }
    }
    
    mutating func draw() -> PlayingSet? {
        if setCards.count > 0 {
            return setCards.remove(at: setCards.count.arc4random)
        } else {
            return nil
        }
    }
        
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = PlayingSet()
            setCards += [card, card, card]
        }
        
        var cardsShuffled = [PlayingSet]()
        for _ in setCards.indices {
            cardsShuffled.append(setCards.remove(at: setCards.count.arc4random))
        }
        setCards = cardsShuffled
    }
    
}

//extension Int {
//    var arc4random: Int {
//        if self > 0 {
//            return Int(arc4random_uniform(UInt32(self)))
//        } else if self < 0 {
//            return -Int(arc4random_uniform(UInt32(self)))
//        } else {
//            return 0
//        }
//    }
//}


/*
 3. A couple of really great methods in Array are index(of:) and contains(). But they
 only work for Arrays of things that implement the Equatable protocol (like Int and
 String do). If you have a data type of your own that you want to put in an Array and
 use index(of:) and contains() on, just make your data type implements Equatable.
 
 4. We kept track of the face up and matched states in Concentration in our Cards. While
 this was great for demonstrating how mutability works in a value type, it might not
 have been the best architecture. Having data structures that are completely
 immutable (i.e. have have no vars, only lets) can make for very clean code. For
 example, in your Set implementation, it’d probably be just as easy to keep a list of all
 the selected cards (or all the already-matched cards) as it would be to have a Bool in
 your Set Card data structure. And you might find the code is much simpler too.
 */
