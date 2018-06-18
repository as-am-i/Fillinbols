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
    var timer = Timer()
    var startTime : Double = 0.0
    var score = 0

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var calculationIndicationLabel: UILabel!
    @IBOutlet weak var fomulaLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
        startTimer()
    }
    
    // MARK: IBActions
    @IBAction func chooseOperator(_ sender: UIButton) {
        if !game.checkGameFinished() {
            
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
            game.calculateScore(currentIndexOfCalculation: indexOfCalculation, score: score)
        
            if calc.isCorrect {
                if indexOfCalculation < 9 {
                    indexOfCalculation += 1
                    calc = game.getCalculation(index: indexOfCalculation)

                    startTimer()
                } else {
                    timer.invalidate()
                    game.setGameFinished()
                    print("Finished 10 calculations")
                }
            }
            
            updateViewFromModel()
        }
    }
    
    //MARK: Helper methods
    private func updateViewFromModel() {
        levelLabel.text = game.getLevel()
        fomulaLabel.text = calc.getFormula()
        scoreCountLabel.text = game.getScoreCount()
        calculationIndicationLabel.text = game.getCalculationIndex(currentIndexOfCalcultion: indexOfCalculation)
    }
    
    func startNewGame() {
        game = Game(gameLevel: .normal)
        calc = game.getCalculation(index: 0)
    }
    
    func startTimer() {
        
        startTime = Date().timeIntervalSince1970 // timeIntervalSince is for sec
        timeCountLabel.text = "Time: 5"
        
        
        // must remove a timer before recreating a new one
        // otherwise, invalidate() method called later will not be executed
        if timer.isValid == true {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(self.updateLabel),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateLabel() {
        let elapsedTime = Date().timeIntervalSince1970 - startTime
        let flooredErapsedTime = Int(floor(elapsedTime)) // to round down
        let leftTime = 5 - flooredErapsedTime
        
        if leftTime >= 0 {
            timeCountLabel.text = "Time: \(leftTime)"
            score = leftTime
        }
    
        if leftTime == 0 {
            // stop timer
            timer.invalidate()
            
            // move to next calculation
            if indexOfCalculation < 9 {
                indexOfCalculation += 1
                calc = game.getCalculation(index: indexOfCalculation)
                
                startTimer()
                updateViewFromModel()
            }

        }
    }

}

