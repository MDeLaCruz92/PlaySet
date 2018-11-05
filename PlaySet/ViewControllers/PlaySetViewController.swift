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
        
    // MARK: Private Properties
    private var deck = PlayingCardDeck()
    private var setBrain: SetBrain? // fix later

    // MARK: Action Methods
    @IBAction func touchCard(_ sender: UIButton) {
        // TODO: Add an Array to use hint: contains and indexOf: array methods
        // will also been to make have to make your data type Equatable idk which
        let cardButtons = startingCardsButtons + remainingCardsButtons
        if let cardNumber = cardButtons.index(of: sender) {
            setBrain?.chooseCard(at: cardNumber)
        }
        
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        // TODO: deal from the remainingCards pile
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
        setupUI()
        
        for _ in startingCardsButtons {
            if let card = setBrain?.draw() {
                print("cards: \(card)")
            }
        }
    }
    
    private func startNewGame() {
        let totalOfNumberOfPairs = ((startingCardsButtons.count + remainingCardsButtons.count) + 1) / 2
        setBrain = SetBrain(numberOfPairsOfCards: totalOfNumberOfPairs)
        print("numerOfPairs: \(SetBrain(numberOfPairsOfCards: totalOfNumberOfPairs))")
    }
    
    // MARK: Private methods
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        startingCardsButtons.forEach { button in
            button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8.0
        }
        
        remainingCardsButtons.forEach { button in
            button.isEnabled = false
            button.isHidden = true
        }
    }


}
