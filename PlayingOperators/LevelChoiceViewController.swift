//
//  LevelChoiceViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-21.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit

class LevelChoiceViewController: UIViewController {
    
    var levelChosen: Game.Level?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func callSegue(_ sender: UIButton) {
        setLevel(button: sender)
        performSegue(withIdentifier: "toCalculationView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalculationView" {
            if let destination = segue.destination as? CalculationViewController {
                destination.levelChosen = levelChosen!
            }
        }
    }
    
    func setLevel(button: UIButton) {
        
        switch button.titleLabel?.text {
        case "EASY":
            levelChosen = Game.Level.easy
        case "NORMAL":
            levelChosen = Game.Level.normal
        case "HARD":
            levelChosen = Game.Level.hard
        default:
            levelChosen = Game.Level.normal
        }
        
    }

}
