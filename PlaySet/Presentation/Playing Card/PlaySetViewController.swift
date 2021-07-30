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
    
    private var deck = PlayingCardDeck()
    private var selectedCardViews = Set<UIView>()
    private var startingCardViews = [UIView]()
    private var remainingCardViews = [UIView]()
    
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
                }
            }
        }
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        if deck.cardsAreMatched {
            handleMatchedCardsState()
        } else {
            deck.penalizeDrawing(visibleCards: playingCardView.subviews.filter { $0.isHidden == false }.count)
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
            if deck.selectedCardsIndex.count > 0 {
                deck.selectedCardsIndex.removeLast()
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
        } else if deck.deckOfCards.isEmpty || noRoomToFitCards() {
            dealCardsButton.disableView()
        }
    }
    
    private func noRoomToFitCards() -> Bool {
        return playingCardView.subviews.allSatisfy({$0.isHidden == false })
    }
    
    private func dealFromRemainingCards() {
        var count = 0
        remainingCardViews.forEach { view in
            if count < dealCardsAmount {
                if view.isHidden {
                    view.isHidden = false
                    count += 1
                }
            }
        }
        count = 0
    }
    
    private func deselectAllCardsIfNescessary() {
        if selectedCardViews.count == selectionLimit {
            resetCardsTouchSelection()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        remainingCardViews.forEach { $0.isHidden = true }
    }
    
    private func handleOutOfCardsState() {
        if deck.deckOfCards.isEmpty {
            deck.selectedCardsIndex.forEach { index in
                playingCardView.subviews[index].disableView()
            }
        }
    }
    
    private func handleMatchedCardsState() {
        if deck.cardsAreMatched {
            handleOutOfCardsState()
            deck.replaceMatchedCards()
            swapMatchedCards()
            resetCardsTouchSelection()
        }
        scoreLabel.text = "Score: \(deck.scoreCount)"
    }
    
    private func swapMatchedCards() {        
        deck.selectedCardsIndex.forEach { index in
            let card = deck.gameDeck[index]
//            let cardAttributedString = NSAttributedString(string: deck.setupCardShapeAmount(card), attributes: setupCardAttributes(card))
//            cardButtons[index].setAttributedTitle(cardAttributedString, for: .normal)
        }
        deck.resetSelectedCards()
    }

    private func updateViewFromModel() {
        deck.setupGameDeck(amountOfCards: 81)
        playingCardView.createGridLayout(amount: deck.gameDeck.count)
        setupCardAttributes()
    }
    
    private func setupCardAttributes() {
        for (index, _) in playingCardView.subviews.enumerated() {
            let card = deck.gameDeck[index]
            print("card: \(card)")
            
            switch card.shading {
            case .striped: playingCardView.shades.append(card.shading.rawValue)
            case .filled:  playingCardView.shades.append(card.shading.rawValue)
            case .notFilled: playingCardView.shades.append(card.shading.rawValue)
            }
            
            switch card.shape {
            case .circle: playingCardView.shapes.append(card.shape.rawValue)
            case .square: playingCardView.shapes.append(card.shape.rawValue)
            case .triangle: playingCardView.shapes.append(card.shape.rawValue)
            }
            
            switch card.amount {
            case .one: playingCardView.shapesAmount.append(card.amount.rawValue)
            case .two: playingCardView.shapesAmount.append(card.amount.rawValue)
            case .three: playingCardView.shapesAmount.append(card.amount.rawValue)
            }
            
            switch card.color {
            case .blue: playingCardView.colors.append(.blue)
            case .green: playingCardView.colors.append(.green)
            case .red: playingCardView.colors.append(.red)
            }
        }
    }
    
    private func resetCardsTouchSelection() {
        selectedCardViews.forEach { $0.applyTouchDeselectionUI() }
        selectedCardViews = []
    }
    
    private func startNewGame() {
        playingCardView.amountOfCells = 12
        dealCardsButton.enableView()
        playingCardView.subviews.forEach { $0.enableView() }
        remainingCardViews.forEach { $0.isHidden = true }
        resetCardsTouchSelection()
        deck = PlayingCardDeck()
        deck.resetSelectedCards()
        deck.setupGameDeck(amountOfCards: playingCardView.amountOfCells)
    }
}
