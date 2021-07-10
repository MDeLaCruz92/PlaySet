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
    private var selectedCardButtons = Set<UIButton>()
    
    // MARK: Action Methods
    
    @IBAction func touchCard(_ sender: UIButton) {
        handleMatchedCardsState()
        handleDealCardsButtonState()
        
//        if let cardNumber = cardButtons.firstIndex(of: sender) {
//            deck.chooseCard(at: cardNumber)
//            cardSelectionResult(button: sender)
//        }
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        if deck.cardsAreMatched {
            handleMatchedCardsState()
        } else {
//            deck.penalizeDrawing(visibleCards: cardButtons.filter { $0.isHidden == false }.count)
//            dealFromRemainingCards()
            scoreLabel.text = "Score: \(deck.scoreCount)"
        }
        
        handleDealCardsButtonState()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        deck.setupGameDeck(amountOfCards: 81)
        updateViewFromModel()
    }
    
    // MARK: Private methods
    
    private func cardSelectionResult(button: UIButton) {
        deselectAllCardsIfNescessary()
        
        if selectedCardButtons.contains(button) {
            button.applyTouchDeselectionUI()
            selectedCardButtons.remove(button)
            if deck.selectedCardsIndex.count > 0 {
                deck.selectedCardsIndex.removeLast()
            }
            if deck.scoreCount > 0 {
                deck.scoreCount -= 1
                scoreLabel.text = "Score: \(deck.scoreCount)"
            }
        } else if selectedCardButtons.count < selectionLimit {
            button.applyTouchSelectionUI()
            selectedCardButtons.insert(button)
        }
        
        handleDealCardsButtonState()
    }
    
    private func handleDealCardsButtonState() {
        if selectedCardButtons.count == selectionLimit
            && deck.cardsAreMatched
            && !deck.deckOfCards.isEmpty {
            dealCardsButton.enableButton()
        } else if deck.deckOfCards.isEmpty || noRoomToFitCards() {
            dealCardsButton.disableButton()
        }
    }
    
    private func noRoomToFitCards() -> Bool {
//        return cardButtons.allSatisfy({$0.isHidden == false })
        return false
    }
    
//    private func dealFromRemainingCards() {
//        var count = 0
//        remainingCardsButtons.forEach { button in
//            if count < dealCardsAmount {
//                if button.isHidden {
//                    button.isHidden = false
//                    count += 1
//                }
//            }
//        }
//        count = 0
//    }
    
    private func deselectAllCardsIfNescessary() {
        if selectedCardButtons.count == selectionLimit {
            resetCardsTouchSelection()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//        playingCardView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        cardButtons.forEach { $0.setupButtonUI() }
//        remainingCardsButtons.forEach { $0.isHidden = true }
        
//        playingCardView.createGridLayout()
    }
    
    private func handleOutOfCardsState() {
        if deck.deckOfCards.isEmpty {
            deck.selectedCardsIndex.forEach { index in
//                cardButtons[index].disableButton()
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
//        for (index, button)  in cardButtons.enumerated() {
//            let card = deck.gameDeck[index]
//            let cardAttributedString = NSAttributedString(string: deck.setupCardShapeAmount(card), attributes: setupCardAttributes(card))
//            button.setAttributedTitle(cardAttributedString, for: .normal)
//        }
        
        playingCardView.amountOfCells = deck.gameDeck.count
        playingCardView.createGridLayout()
    }
    
    private func setupCardAttributes() {
        for _ in 0...deck.gameDeck.count {
            
        }
    }
    
    private func setupCardAttributes(_ card: PlayingCard) -> [NSAttributedString.Key : Any]   {
        let cardFadedAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : setupCardColor(card).withAlphaComponent(0.30)]
        let cardFilledAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: setupCardColor(card).withAlphaComponent(1)]
        let cardNotFilledAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor: setupCardColor(card),
            .strokeWidth: 10.0
        ]
        
        switch card.shading {
        case .striped: return cardFadedAttributes
        case .filled: return cardFilledAttributes
        case .notFilled: return cardNotFilledAttributes
        }
    }
    
    private func setupCardColor(_ card: PlayingCard) -> UIColor {
        switch card.color {
        case .blue: return UIColor.blue
        case .green: return UIColor.green
        case .red: return UIColor.red
        }
    }
    
    private func resetCardsTouchSelection() {
        selectedCardButtons.forEach { $0.applyTouchDeselectionUI() }
        selectedCardButtons = []
    }
    
    private func startNewGame() {
        playingCardView.amountOfCells = 81
        dealCardsButton.enableButton()
//        cardButtons.forEach { $0.enableButton() }
//        remainingCardsButtons.forEach { $0.isHidden = true }
        resetCardsTouchSelection()
        deck = PlayingCardDeck()
        deck.resetSelectedCards()
//        deck.setupGameDeck(amountOfCards: cardButtons.count)
        updateViewFromModel()
    }

}
