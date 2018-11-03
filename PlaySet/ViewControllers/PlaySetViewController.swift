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

    // MARK: Action Methods
    @IBAction func touchCard(_ sender: UIButton) {
        // TODO: Add an Array to use hint: contains and indexOf: array methods
        // will also been to make have to make your data type Equatable idk which
        
    }
    
    @IBAction func dealCardsButton(_ sender: UIButton) {
        
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        for _ in startingCardsButtons {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
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
    
    private func resetSelectedButtons() {
        
    }

}
