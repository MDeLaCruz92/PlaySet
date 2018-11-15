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
    private(set) var selectedCards = Set<PlayingSet>()
    private let selectionLimit = 3

    static let matchPoints = 2
    static let misMatchPenalty = 1
    
    init() {
        for shape in PlayingSet.Shape.allCases {
            for amount in PlayingSet.Amount.allCases {
                for shading in PlayingSet.Shading.allCases {
                    for color in PlayingSet.Color.allCases {
                        setCards.append(PlayingSet(shape: shape, amount: amount, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    enum CardFeatureMatch {
        case allSame
        case allDifferent
    }
    
    mutating func chooseCard(at index: Int)  {
        selectCards(index)
    }
    
    mutating func draw() -> PlayingSet? {
        if setCards.count > 0 {
            return setCards.remove(at: setCards.count.arc4random)
        } else {
            return nil
        }
    }
    
    private mutating func selectCards(_ index: Int) {
        if selectedCards.count < selectionLimit {
            selectedCards.insert(setCards[index])
            print("***Select cards in SetBrain: \(selectedCards)")
        }
        if selectedCards.count == selectionLimit {
            selectedCards = []
        }
    }
    
}

//var cardsShuffled = [PlayingSet]()
//for _ in setCards.indices {
//    cardsShuffled.append(setCards.remove(at: setCards.count.arc4random))
//}
//setCards = cardsShuffled

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
