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
    
    @IBOutlet var startingCardsButtons: [UIButton]!
    @IBOutlet var remainingCardsButtons: [UIButton]!
    @IBOutlet var cardButtons: [UIButton]!
    
    private let selectionLimit = 3
    private let dealCardsAmount = 3
    
    private var deck = PlayingCardDeck()
    private var selectedCardButtons = Set<UIButton>()
    
    // MARK: Action Methods
    @IBAction func touchCard(_ sender: UIButton) {
        handleMatchedCardsState()
        handleDealCardsButtonState()
        
        if let cardNumber = cardButtons.index(of: sender) {
            deck.chooseCard(at: cardNumber)
            cardSelectionResult(button: sender)
        }
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        if deck.selectedCardsAreMatched() {
            handleMatchedCardsState()
        } else {
            dealFromRemainingCards()
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
        deck.setupGameDeck(amountOfCards: cardButtons.count)
        updateViewFromModel()
    }
    
    // MARK: Private methods
    private func cardSelectionResult(button: UIButton) {
        deselectAllCardsIfNescessary()
        
        if selectedCardButtons.contains(button) {
            button.applyTouchDeselectionUI()
            selectedCardButtons.remove(button)
            deck.selectedCardsIndex.removeLast()
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
            && deck.selectedCardsAreMatched()
            && !deck.deckOfCards.isEmpty {
            dealCardsButton.enableButton()
        } else if deck.deckOfCards.isEmpty || noRoomToFitCards() {
            dealCardsButton.disableButton()
        }
    }
    
    private func noRoomToFitCards() -> Bool {
        return cardButtons.allSatisfy({$0.isHidden == false })
    }
    
    private func dealFromRemainingCards() {
        var count = 0
        remainingCardsButtons.forEach { button in
            if count < dealCardsAmount {
                if button.isHidden {
                    button.isHidden = false
                    count += 1
                }
            }
        }
        count = 0
    }
    
    private func deselectAllCardsIfNescessary() {
        if selectedCardButtons.count == selectionLimit {
            resetCardsTouchSelection()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        cardButtons.forEach { $0.setupButtonUI() }
        remainingCardsButtons.forEach { $0.isHidden = true }
    }
    
    private func handleMatchedCardsState() {
        if deck.selectedCardsAreMatched() {
            deck.replaceMatchedCards()
            swapMatchedCards()
            resetCardsTouchSelection()
        }
        scoreLabel.text = "Score: \(deck.scoreCount)"
    }
    
    private func swapMatchedCards() {
        deck.selectedCardsIndex.forEach { index in
            let card = deck.gameDeck[index]
            let cardAttributedString = NSAttributedString(string: setupCardShapeAmount(card), attributes: setupCardAttributes(card))
            cardButtons[index].setAttributedTitle(cardAttributedString, for: .normal)
        }
        deck.resetSelectedCards()
    }

    private func updateViewFromModel() {
        for (index, button)  in cardButtons.enumerated() {
            let card = deck.gameDeck[index]
            let cardAttributedString = NSAttributedString(string: setupCardShapeAmount(card), attributes: setupCardAttributes(card))
            button.setAttributedTitle(cardAttributedString, for: .normal)
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
        case .faded: return cardFadedAttributes
        case .filled: return cardFilledAttributes
        case .notFilled: return cardNotFilledAttributes
        }
    }
    
    private func setupCardShapeAmount(_ card: PlayingCard) -> String {
        switch card.amount {
        case .one: return card.shape.rawValue
        case .two: return card.shape.rawValue + card.shape.rawValue
        case .three: return card.shape.rawValue + card.shape.rawValue + card.shape.rawValue
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
        dealCardsButton.isEnabled = true
        remainingCardsButtons.forEach { $0.isHidden = true }
        resetCardsTouchSelection()
        deck = PlayingCardDeck()
        deck.resetSelectedCards()
        deck.setupGameDeck(amountOfCards: cardButtons.count)
        updateViewFromModel()
    }

}
