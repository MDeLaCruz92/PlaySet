//
//  SetBrain.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 11/2/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    
    private var deckOfCards = [PlayingCard]()
    private var gameDeck = [PlayingCard]()
    
//    private(set) var selectedCards = Set<PlayingCard>()
    private let selectionLimit = 3

    static let matchPoints = 2
    static let misMatchPenalty = 1
    
    init() {
        for shape in PlayingCard.Shape.allCases {
            for amount in PlayingCard.Amount.allCases {
                for shading in PlayingCard.Shading.allCases {
                    for color in PlayingCard.Color.allCases {
                        deckOfCards.append(PlayingCard(shape: shape, amount: amount, shading: shading, color: color, cardState: .notSelected))
                    }
                }
            }
        }
    }
        
    mutating func chooseCard(at index: Int)  {
        gameDeck[index].cardState = .selected
        let selectedCards = gameDeck.filter { $0.cardState == PlayingCard.CardState.selected }
        matchFeature(at: index, selectedCards: selectedCards)
        print("chooseCard: \(gameDeck[index].cardState)")
//        selectCards(at: index)
    }
    
    mutating func setupGameDeck(amountOfCards: Int) {
        for _ in 1...amountOfCards {
            if let card = draw() {
                print("cards: \(card)")
                gameDeck.append(card)
            }
        }
    }

    // MARK: Private Methods
    private mutating func draw() -> PlayingCard? {
        if !deckOfCards.isEmpty {
            return deckOfCards.remove(at: deckOfCards.count.arc4random)
        } else {
            return nil
        }
    }
    
    private mutating func matchFeature(at index: Int, selectedCards: [PlayingCard]) {
        switch gameDeck[index].cardState {
        case .matched: matched(at: index, selectedCards: selectedCards)
        case .selected: selectState(at: index, selectedCards: selectedCards)
        default: noMatch(at: index)
        }
        print("selectedCards: \(selectedCards)")
    }
    
    private func matched(at Index: Int , selectedCards: [PlayingCard]) {
        let allAmountMatch = selectedCards.allSatisfy({ $0.amount == selectedCards.first?.amount })
        let allColorMatch = selectedCards.allSatisfy( { $0.color == selectedCards.first?.color })
        let allShadingMatch = selectedCards.allSatisfy({ $0.shading == selectedCards.first?.shading })
        let allShapeMatch = selectedCards.allSatisfy({ $0.shape == selectedCards.first?.shape })
        
        print("allStatisfyAmount: \(allAmountMatch)")
        print("allStatisfyColor: \(allColorMatch)")
        print("allStatisfyShading: \(allShadingMatch)")
        print("allStatisfyShape: \(allShapeMatch)")
        
//        if selectedCards[0].amount == selectedCards[1].amount && selectedCards[1].amount == selectedCards[2].amount ||
//            selectedCards[0].amount != selectedCards[1].amount && selectedCards[1].amount != selectedCards[2].amount {
//
//        }
//        if selectedCards[0].color == selectedCards[1].color && selectedCards[1].color == selectedCards[2].color ||
//            selectedCards[0].color != selectedCards[1].color && selectedCards[1].color != selectedCards[2].color {
//
//        }
//        if selectedCards[0].shading == selectedCards[1].shading && selectedCards[1].shading == selectedCards[2].shading ||
//            selectedCards[0].shading != selectedCards[1].shading && selectedCards[1].shading != selectedCards[2].shading{
//        }
//        if selectedCards[0].shape == selectedCards[1].shape && selectedCards[1].shape == selectedCards[2].shape {
//        }
    }
    
    private mutating func noMatch(at index: Int) {
    }
    
    private mutating func selectState(at index: Int, selectedCards: [PlayingCard]) {
        if selectedCards.count == selectionLimit {
            gameDeck[index].cardState = PlayingCard.CardState.matched
        } else {
            gameDeck[index].cardState = .notSelected
        }
    }
    
    private func notSelected(at index: Int) {
    }
    
//    private mutating func selectCards(at  index: Int) {
//        if selectedCards.count < selectionLimit {
//            selectedCards.insert(gameDeck[index])
//            print("***Select cards in PlayingCardDeck: \(selectedCards)")
//        }
//        if selectedCards.count == selectionLimit {
//            matchFeature(at: index)
//            selectedCards = []
//        }
//    }
    
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
