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
    
    private(set) var selectedCardsIndex = Set<Int>()
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
        handleSelectState(at: index)
        print("chooseCard: \(gameDeck[index].cardState)")
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
    
    private mutating func handleSelectState(at index: Int) {
//        gameDeck[index].cardState = gameDeck[index].cardState == .selected ? .notSelected : .selected
        if gameDeck[index].cardState == .selected {
            gameDeck[index].cardState = .notSelected
        } else {
            gameDeck[index].cardState = .selected
            selectedCardsIndex.insert(index)
        }
        let selectedCards = gameDeck.filter { $0.cardState == .selected }
        
        switch gameDeck[index].cardState {
        case .selected: selectState(selectedCards)
        case .notSelected: notSelected()
        case .matched: print("Might have to do something in the UI. This may not be a great idea...")
        }
        print("selectedCards: \(selectedCards)")
    }
    
    private mutating func handleMatchState(_ selectedCards: [PlayingCard]) {
        let cardsFeatureMatch = [shapeMatchState(for: selectedCards), amountMatchState(for: selectedCards), shadingMatchState(for: selectedCards), colorMatchState(for: selectedCards)]
        print("result of matching:  \(cardsFeatureMatch)")
        if cardsFeatureMatch.allSatisfy( { $0 == true }) {
            print("Cards MATCH!!!!")
            cardsAreMatched(selectedCards)
        } else {
            print("Cards DOES NOT MATCH!!!!")
            cardsDoNotMatch(selectedCards)
        }
    }
    
    private func amountMatchState(for cards: [PlayingCard]) -> Bool  {
        let allTrue =  cards[0].amount == cards[1].amount && cards[1].amount == cards[2].amount
        let allFalse = cards[0].amount != cards[1].amount && cards[1].amount != cards[2].amount && cards[0].amount != cards[2].amount
        return allTrue || allFalse
    }
    
    private func colorMatchState(for cards: [PlayingCard]) -> Bool {
        let allTrue = cards[0].color == cards[1].color && cards[1].color == cards[2].color
        let allFalse = cards[0].color != cards[1].color && cards[1].color != cards[2].color && cards[0].color != cards[2].color
        return allTrue || allFalse
    }
    
    private func shadingMatchState(for cards: [PlayingCard]) -> Bool {
        let allTrue = cards[0].shading == cards[1].shading && cards[1].shading == cards[2].shading
        let allFalse = cards[0].shading != cards[1].shading && cards[1].shading != cards[2].shading && cards[0].shading != cards[2].shading
        return allTrue || allFalse
    }
    
    private func shapeMatchState(for cards: [PlayingCard]) -> Bool {
        let allTrue =  cards[0].shape == cards[1].shape && cards[1].shape == cards[2].shape
        let allFalse = cards[0].shape != cards[1].shape && cards[1].shape != cards[2].shape && cards[0].shape != cards[2].shape
        return allTrue || allFalse
    }
    
    private mutating func cardsAreMatched(_ selectedCards: [PlayingCard]) {
        selectedCardsIndex.forEach { index in
            print("BEFORE: \(gameDeck[index].cardState)")
            gameDeck[index].cardState = .matched
            print("AFTER: \(gameDeck[index].cardState)")
        }
    }
    
    private mutating func cardsDoNotMatch(_ selectedCards: [PlayingCard]) {
        selectedCardsIndex.forEach { index in
            gameDeck[index].cardState = .notSelected
        }
        selectedCardsIndex = []
    }
    
    private mutating func selectState(_ selectedCards: [PlayingCard]) {
        if selectedCards.count == selectionLimit {
            handleMatchState(selectedCards)
        }
    }
    
    private mutating func notSelected() {
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
