//
//  CalculationViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-12.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController {
    
    // MARK: Properties
    var levelChosen : Game.Level?
    
    lazy var game = Game(gameLevel: levelChosen!) // never forget "lazy"
    
    private var indexOfCalculation = 0
    
    private var calc : Calculation {
        get { return game.getCalculation(index: indexOfCalculation) }
        set {
             
        }
    }
    
    var timer = Timer()
    var startTime : Double = 0.0
    var score = 0
    
    let countDownLabel = UILabel()

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var calculationIndicationLabel: UILabel!
    @IBOutlet weak var fomulaLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var multiplicationButton: UIButton!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    
    private var operatorButtons : [UIButton] {
        get { return [additionButton, subtractionButton, multiplicationButton, divisionButton, reminderButton] }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
        countDown()
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
            case "%":
                index = Calculation.OperatorType.modulus.rawValue
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
                    callSegue()
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
            } else {
                game.setGameFinished()  
                callSegue()
            }
        }
    }
    
    func callSegue() {
        if game.checkGameFinished() {
            // move to result view
            performSegue(withIdentifier: "toResultView", sender: nil)
        }
    }
    
    // segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultView" {
            if let destination = segue.destination as? ResultViewController {
                destination.finalScore = game.scoreCount
                destination.level = game.getLevel()
            }
        }
    }
    
    func countDown() {
        // hide calculations for 4 sec
        calculationIndicationLabel.isHidden = true
        fomulaLabel.isHidden = true
        
        // disable buttons for 4 sec
        disAbleAllOperators()
        
        // set up countDownLabel
        countDownLabel.text = "3"
        countDownLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.thin)
        countDownLabel.textColor = UIColor.darkGray
        countDownLabel.sizeToFit()
        countDownLabel.center = self.view.center
        self.view.addSubview(countDownLabel)
        
        startTime = Date().timeIntervalSince1970 // timeIntervalSince is for sec
        if timer.isValid == true {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(self.updateCountDown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateCountDown() {
        let elapsedTime = Date().timeIntervalSince1970 - startTime
        let flooredErapsedTime = Int(floor(elapsedTime)) // to round down
        let leftTime = 3 - flooredErapsedTime // 3 2 1 GO
        
        if leftTime >= 0 {
            countDownLabel.text = "\(leftTime)"
        }
        if leftTime == 0 {
            countDownLabel.text = "GO!"
            
            countDownLabel.textColor = UIColor.red
            countDownLabel.sizeToFit()
            countDownLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.medium)
            countDownLabel.center = self.view.center
            countDownLabel.textAlignment = .center
        }
        if leftTime <= -1 {
            // stop countdown
            timer.invalidate()
        
            // show calculation
            countDownLabel.isHidden = true
            calculationIndicationLabel.isHidden = false
            fomulaLabel.isHidden = false
            
            // allow user tap on the buttons according to game level
            setUpOperators(gameLevel: levelChosen!)
    
            startTimer()
        }
    }
    
    func setUpOperators(gameLevel: Game.Level) {
        switch gameLevel {
        case .easy:
            toggleOperatorButtons(indexesOfOperators: [0, 1], isEnabled: true, isHidden: false)
        case .normal:
            toggleOperatorButtons(indexesOfOperators: [0, 1, 2, 3], isEnabled: true, isHidden: false)
        case .hard:
            toggleOperatorButtons(indexesOfOperators: [0, 1, 2, 3, 4], isEnabled: true, isHidden:false)
        }
    }
    
    func disAbleAllOperators() {
        toggleOperatorButtons(indexesOfOperators: [0, 1, 2, 3, 4], isEnabled: false, isHidden: true)
    }
    
    func toggleOperatorButtons(indexesOfOperators: [Int], isEnabled: Bool, isHidden: Bool) {
        for index in indexesOfOperators {
            if index < 5 { // max: 5 operators
                operatorButtons[index].isEnabled = isEnabled
                operatorButtons[index].isHidden = isHidden
            }
        }
    }
}

