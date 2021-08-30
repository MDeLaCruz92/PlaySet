//
//  PlaySetViewController.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/6/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import UIKit

class PlaySetViewController: UIViewController {
    
    static let instance = PlaySetViewController()

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var playingCardView: PlayingCardView!
    
    private let selectionLimit = 3
    private let dealCardsAmount = 3
    private let startingAmountOfCards = 12
    
    private var deck = PlayingCardDeck()
    private var selectedCardViews = Set<UIView>()
    
    // MARK: Action Methods
    
    @IBAction func selectCard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            handleMatchedCardsState()
            handleDealCardsViewState()
            
            let viewLocation = sender.location(in: playingCardView)
            
            for (index, tappedView) in playingCardView.subviews.enumerated() {
                 if tappedView.frame.contains(viewLocation) {
                    deck.chooseCard(at: index)
                    cardSelectionResult(view: tappedView)
                    
                    print("card \(index): \(deck.gameDeck[index])")
                }
            }
        }
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        if deck.cardsAreMatched {
            handleMatchedCardsState()
        } else {
            deck.penalizeDrawing(visibleCards: playingCardView.subviews.count)
            dealFromRemainingCards()
            scoreLabel.text = "Score: \(deck.scoreCount)"
        }
        handleDealCardsViewState()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    // MARK: Private methods
    
    private func cardSelectionResult(view: UIView) {
        deselectAllCardsIfNescessary()
        
        if selectedCardViews.contains(view) {
            view.applyTouchDeselectionUI()
            selectedCardViews.remove(view)
            if !deck.selectedCards.isEmpty {
                deck.selectedCards.removeLast()
            }
            if deck.scoreCount > 0 {
                deck.scoreCount -= 1
                scoreLabel.text = "Score: \(deck.scoreCount)"
            }
        } else if selectedCardViews.count < selectionLimit {
            view.applyTouchSelectionUI()
            selectedCardViews.insert(view)
        }
        handleDealCardsViewState()
    }
    
    private func handleDealCardsViewState() {
        if selectedCardViews.count == selectionLimit
            && deck.cardsAreMatched
            && !deck.deckOfCards.isEmpty {
            dealCardsButton.enableView()
        } else if deck.deckOfCards.isEmpty {
            dealCardsButton.disableView()
        }
    }
    
    private func dealFromRemainingCards() {
        deck.setupGameDeck(amountOfCards: dealCardsAmount)
        
        var count = 3
        
        for _ in 1...dealCardsAmount {
            let card = deck.gameDeck[deck.gameDeck.endIndex - count]
            count -= 1
            setupAttributes(with: card)
        }
        
        playingCardView.amountOfCells += dealCardsAmount
        playingCardView.createGridLayout(amount: dealCardsAmount)
    }
    
    private func deselectAllCardsIfNescessary() {
        if selectedCardViews.count == selectionLimit {
            resetCardsTouchSelection()
        }
    }
    
    private func handleMatchedCardsState() {
        if deck.cardsAreMatched {

            swapMatchedCards()
            
            deck.replaceMatchedCards()
            resetCardsTouchSelection()
        }
        scoreLabel.text = "Score: \(deck.scoreCount)"
    }
    
    private func swapMatchedCards() {
        deck.selectedCards.forEach { selectedCard in
            guard let index = deck.gameDeck.firstIndex(of: selectedCard) else { return }
            
            if let card = deck.draw() {
                playingCardView.attributes[index] = .init(color: color(of: card),
                                                          shade: card.shading.rawValue,
                                                          shape: card.shape.rawValue,
                                                          amount: card.amount.rawValue)
                deck.gameDeck[index] = card
            } else {
                playingCardView.attributes.remove(at: index)
                playingCardView.subviews[index].removeFromSuperview()
                playingCardView.amountOfCells -= 1
                deck.gameDeck.remove(at: index)
            }
        }
        playingCardView.updateLayoutAndDisplay()
        deck.resetSelectedCards()
    }

    private func updateViewFromModel() {
        deck.setupGameDeck(amountOfCards: startingAmountOfCards)
        playingCardView.createGridLayout(amount: startingAmountOfCards)
        
        for (index, _) in playingCardView.subviews.enumerated() {
            setupAttributes(with: deck.gameDeck[index])
        }
    }
    
    private func setupAttributes(with card: PlayingCard) {
        playingCardView.attributes.append(.init(color: color(of: card), shade: card.shading.rawValue, shape: card.shape.rawValue, amount: card.amount.rawValue))
    }
    
    private func color(of card: PlayingCard) -> UIColor {
        switch card.color {
        case .blue: return .blue
        case .green: return .green
        case .red: return .red
        }
    }
    
    private func resetCardsTouchSelection() {
        selectedCardViews.forEach { $0.applyTouchDeselectionUI() }
        selectedCardViews = []
    }
    
    private func startNewGame() {
        playingCardView.amountOfCells = startingAmountOfCards
        dealCardsButton.enableView()
        playingCardView.subviews.forEach { $0.enableView() }
        resetCardsTouchSelection()
        deck = PlayingCardDeck()
        deck.resetSelectedCards()
        deck.setupGameDeck(amountOfCards: playingCardView.amountOfCells)
    }
}
