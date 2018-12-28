//
//  SetBrain.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 11/2/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    
    var selectedCardsIndex = [Int]()
    var scoreCount = 0
    
    private(set) var deckOfCards = [PlayingCard]()
    private(set) var gameDeck = [PlayingCard]()
    private var isMatched = false
    
    private let selectionLimit = 3
    private let matchPoints = 3
    private  let misMatchPenalty = 2
    
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
    
    mutating func resetSelectedCards() {
        selectedCardsIndex.forEach { index in
            gameDeck[index].cardState = .notSelected
        }
        selectedCardsIndex.removeAll()
    }
    
    mutating func replaceMatchedCards() {
        selectedCardsIndex.forEach { index in
            if let card = draw() {
                gameDeck[index] = card
            }
        }
        isMatched = false
    }
    
    mutating func selectedCardsAreMatched() -> Bool  {
        return isMatched
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
        if gameDeck[index].cardState == .selected {
            gameDeck[index].cardState = .notSelected
        } else {
            gameDeck[index].cardState = .selected
            if !selectedCardsIndex.contains(index) {
                selectedCardsIndex.append(index)
                print(selectedCardsIndex)
            }
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
        if cardsFeatureMatch.allSatisfy( { $0 == true }) {
            print("Cards MATCH!!!!")
            isMatched = true
            scoreCount += matchPoints
        } else {
            print("Cards DOES NOT MATCH!!!!")
            resetSelectedCards()
            handleMisMatchScore()
        }
    }
    
    private mutating func handleMisMatchScore() {
        if scoreCount > 0 {
            scoreCount -= misMatchPenalty
        }
        if scoreCount < 0 {
            scoreCount = 0
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
    
    private mutating func selectState(_ selectedCards: [PlayingCard]) {
        if selectedCards.count == selectionLimit {
            handleMatchState(selectedCards)
        }
    }
    
    private mutating func notSelected() {
    }
    
    
    
}
