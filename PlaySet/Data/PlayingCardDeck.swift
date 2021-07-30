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
    private(set) var cardsAreMatched = false
    
    private var date = Date()
    private var currentDate: Date { return Date() }
    
    private  var timeInterval: Int {
        return Int(-date.timeIntervalSinceNow)
    }
    
    private let selectionLimit = 3
    private let matchPoints = 2
    private let misMatchPenalty = 2
    private let matchTimeBonus = 3
    private let maxTimePenalty = 4
    private let maxTimer = 10
    
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
    
    mutating func setupGameDeck(amountOfCards: Int) {
        for _ in 1...amountOfCards {
            if let card = draw() {
                gameDeck.append(card)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        handleSelectState(at: index)
    }
    
    mutating func penalizeDrawing(visibleCards: Int) {
        var selectedCards = [PlayingCard]()
        for index in 1..<visibleCards {
            selectedCards.append(gameDeck[index])
            let remainingCards = gameDeck[index+1..<visibleCards]
            for secondCard in remainingCards {
                selectedCards.append(secondCard)
                let lastRemainingCards = gameDeck[index+2..<visibleCards]
                for thirdCard in lastRemainingCards {
                    selectedCards.append(thirdCard)
                    if selectedCards.count == selectionLimit {
                        let cardsFeatureMatch = [shapeMatchState(selectedCards), amountMatchState(selectedCards), shadingMatchState(selectedCards), colorMatchState(selectedCards)]
                        if cardsFeatureMatch.allSatisfy( { $0 == true }) {
                        handleMisMatchScore()
                        selectedCards = []
                        return
                        }
                        selectedCards.removeLast()
                    }
                }
                selectedCards.removeLast()
            }
            selectedCards = []
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
        cardsAreMatched = false
    }
    
    // MARK: Private Methods
    
    mutating func draw() -> PlayingCard? {
        if !deckOfCards.isEmpty {
            return deckOfCards.remove(at: deckOfCards.count.arc4random)
        } else {
            return nil
        }
    }
    
    // MARK: Select State
    
    private mutating func handleSelectState(at index: Int) {
        if gameDeck[index].cardState == .selected {
            gameDeck[index].cardState = .notSelected
        } else {
            gameDeck[index].cardState = .selected
            if !selectedCardsIndex.contains(index) {
                selectedCardsIndex.append(index)
            }
        }
        let selectedCards = gameDeck.filter { $0.cardState == .selected }
        
        switch gameDeck[index].cardState {
        case .selected: selectState(selectedCards)
        case .notSelected: print("Card has been unselected")
        }
    }
    
    private mutating func selectState(_ selectedCards: [PlayingCard]) {
        if selectedCards.count == selectionLimit {
            handleMatchState(selectedCards)
        }
    }

    // MARK: Match State
    
    private mutating func handleMatchState(_ selectedCards: [PlayingCard]) {
        let cardsFeatureMatch = [shapeMatchState(selectedCards), amountMatchState(selectedCards), shadingMatchState(selectedCards), colorMatchState(selectedCards)]
        if cardsFeatureMatch.allSatisfy( { $0 == true }) {
            cardsAreMatched = true
            scoreCount += timeInterval > maxTimer ? matchPoints : matchPoints + matchTimeBonus
        } else {
            resetSelectedCards()
            handleMisMatchScore()
        }
        date = currentDate
    }
    
    private mutating func handleMisMatchScore() {
        if scoreCount > 0 {
            scoreCount -= timeInterval > maxTimer ? misMatchPenalty + maxTimePenalty : misMatchPenalty
        }
        if scoreCount < 0 {
            scoreCount = 0
        }
    }
    
    private func featureMatchState(allTrue: Bool, allFalse: Bool) -> Bool {
        return allTrue || allFalse
    }
    
    private func amountMatchState(_ cards: [PlayingCard]) -> Bool  {
        let amount = cards.compactMap { $0.amount }
        return featureMatchState(allTrue: amount[0] == amount[1] && amount[1] == amount[2], allFalse: amount[0] != amount[1] && amount[1] != amount[2] && amount[0] != amount[2])
    }
    
    private func colorMatchState(_ cards: [PlayingCard]) -> Bool {
        let color = cards.compactMap { $0.color }
        return featureMatchState(allTrue: color[0] == color[1] && color[1] == color[2], allFalse: color[0] != color[1] && color[1] != color[2] && color[0] != color[2])
    }
    
    private func shadingMatchState(_ cards: [PlayingCard]) -> Bool {
        let shading = cards.compactMap { $0.shading }
        return featureMatchState(allTrue: shading[0] == shading[1] && shading[1] == shading[2], allFalse:  shading[0] != shading[1] && shading[1] != shading[2] && shading[0] != shading[2])
    }
    
    private func shapeMatchState(_ cards: [PlayingCard]) -> Bool {
        let shape = cards.compactMap { $0.shape }
        return featureMatchState(allTrue: shape[0] == shape[1] && shape[1] == shape[2], allFalse: shape[0] != shape[1] && shape[1] != shape[2] && shape[0] != shape[2])
    }
    
}
