//
//  ViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-12.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    private var game = Game(gameLevel: .normal)
    private var indexOfCalculation = 0
    private var calc : Calculation {
        get { return game.getCalculation(index: indexOfCalculation) }
        set {
             
        }
    }

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var fomulaLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
    }
    
    // MARK: IBActions
    @IBAction func chooseOperator(_ sender: UIButton) {
        var index : Int
        
        switch sender.titleLabel?.text {
        case "➕":
            index = Calculation.OperatorType.addition.rawValue
        case "➖":
            index = Calculation.OperatorType.substraction.rawValue
        case "✖️":
            index = Calculation.OperatorType.multiplication.rawValue
        case "➗":
            index = Calculation.OperatorType.division.rawValue
        default:
            index = 0
        }

        calc.checkAnswerIsCorrect(choice: calc.allOperatorTypes[index])
        if indexOfCalculation < 9 {
            if calc.isCorrect {
                indexOfCalculation += 1
                calc = game.getCalculation(index: indexOfCalculation)
            }
        } else {
            print("Finished 10 calculations")
        }
        
        updateViewFromModel()
    }
    
    //MARK: Helper methods
    private func updateViewFromModel() {
        levelLabel.text = game.getLevel()
        fomulaLabel.text = calc.getFormula()
        timeCountLabel.text = calc.getTimeCount()
        
    }
    
    func startNewGame() {
        game = Game(gameLevel: .normal)
//        calc = game.getCalculation(index: 0)
    }

}

