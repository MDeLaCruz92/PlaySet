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
    
    private let cardAttributes: [NSAttributedString.Key : Any] = [
        .strokeColor : UIColor.orange,
        .strokeWidth : 5.0
        
    ]
    
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
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = deck.gameDeck[index]
            
            let cardAttributedString = NSAttributedString(string: button.title(for: .normal)!, attributes: cardAttributes)
            
        }
    }
    
    private func setupCardsUI() {
       
    }
    
    private func startNewGame() {
        remainingCardsButtons.forEach { $0.isHidden = true }
        deck.setupGameDeck(amountOfCards: cardButtons.count)
    }

}


// "▲●■"
