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
    
    @IBOutlet var startingCardsButtons: [UIButton]!
    @IBOutlet var remainingCardsButtons: [UIButton]!
    @IBOutlet var cardButtons: [UIButton]!
    
    // MARK: Private Properties
    private let selectionLimit = 3
    private let dealCardsAmount = 3
    
    private var deck = PlayingCardDeck()
    private var selectedCardButtons = Set<UIButton>()
    
    // MARK: Action Methods
    @IBAction func touchCard(_ sender: UIButton) {
        // TODO: Add an Array to use hint: contains and indexOf: array methods
        // will also been to make have to make your data type Equatable idk which
        if let cardNumber = cardButtons.index(of: sender) {
            deck.chooseCard(at: cardNumber)
            cardSelectionResult(button: sender)
        }
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        // TODO: Refactor
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
        } else if selectedCardButtons.count < selectionLimit {
            button.applyTouchSelectionUI()
            selectedCardButtons.insert(button)
        }
//        print("*** selectedCards: \(selectedCardButtons.count)")
    }
    
    private func deselectAllCardsIfNescessary() {
        if selectedCardButtons.count == selectionLimit {
            selectedCardButtons.forEach { $0.applyTouchDeselectionUI() }
            selectedCardButtons = []
        }
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        cardButtons.forEach { $0.setupButtonUI() }
        remainingCardsButtons.forEach { $0.isHidden = true }
    }
    
    private func updateViewFromModel() {
        for (index, button)  in cardButtons.enumerated() {
            let card = deck.gameDeck[index]
            let cardAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor :  setupCardColor(card, button),
                .foregroundColor: UIColor.yellow.withAlphaComponent(1)
            ]
            let cardAttributedString = NSAttributedString(string: card.shape.rawValue, attributes: cardAttributes)
            button.setAttributedTitle(cardAttributedString, for: .normal)
        }
    }
    
//    private func setupCardShading(_ card: PlayingCard, _ button: UIButton) -> UIColor {
//
//    }
    
    private func setupCardColor(_ card: PlayingCard, _ button: UIButton) -> UIColor {
        switch card.color {
        case .blue: return UIColor.blue
        case .green: return UIColor.green
        case .red: return UIColor.red
        }
    }
    
    private func startNewGame() {
        remainingCardsButtons.forEach { $0.isHidden = true }
        deck.setupGameDeck(amountOfCards: cardButtons.count)
    }

}


// "▲●■"


/*
 
 - get the shape propoerly -> DONE
 - get the color properly
 - get the amount of shapes
 - fill the shape properly
 
 
 let cardAttributes: [NSAttributedString.Key : Any] = [
 .strokeColor :  setupCardColor(card, button),
 .strokeWidth : 10.0,
 .foregroundColor: setupCardColor(card, button).withAlphaComponent(0.15)
 ]
 
 */
