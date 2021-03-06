//
//  CalculationViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-12.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit
import CoreData

class CalculationViewController: UIViewController {
    
    // MARK: Properties
    
    var managedObjectContext: NSManagedObjectContext!
    
    var levelChosen : Game.Level?
    
    lazy var game = Game(context: managedObjectContext!)
    
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
    let circle = UIView()
    let circleLabel = UILabel()
    let crossLabel = UILabel()

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var calculationIndicationLabel: UILabel!
    @IBOutlet weak var fomulaLabel: UILabel!
    @IBOutlet weak var fomulaResultLabel: UILabel!
    
    
    @IBOutlet weak var exponentLabel: UILabel!
    
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
        game.setupGameProperties(gameLevel: levelChosen!)
        
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
                
                showCircleLabel()
                
                if indexOfCalculation < 9 {
                    indexOfCalculation += 1
                    calc = game.getCalculation(index: indexOfCalculation)

                    startTimer()
                } else {
                    timer.invalidate()
                    game.setGameFinished()
                    callSegue()
                }
            } else {
                showCrossLabel()
            }
        
        updateViewFromModel()
        }
    }
    
    //MARK: Helper methods
    private func updateViewFromModel() {
        levelLabel.text = game.getLevel()
        fomulaLabel.text = calc.getFormula(level: levelChosen!)
        fomulaResultLabel.text = calc.getFomulaResult()
        
        if levelChosen == Game.Level.dieHard {
            exponentLabel.text = calc.getFomulaExponent()
        }
        
        timeCountLabel.text = game.getCalculationTimeAsString()
        scoreCountLabel.text = game.getScoreCount()
        calculationIndicationLabel.text = game.getCalculationIndex(currentIndexOfCalcultion: indexOfCalculation)
    }
    
    func startTimer() {
        
        startTime = Date().timeIntervalSince1970 // timeIntervalSince is for sec
        
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
        let leftTime = game.getCalculationTimeAsInt() - flooredErapsedTime
        
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
                destination.finalScore = Int(game.score)
                destination.level = game.getLevel()
                destination.game = game
                destination.managedObjectContext = managedObjectContext
            }
        }
    }
    
    func countDown() {
        // hide calculations for 4 sec
        calculationIndicationLabel.isHidden = true
        fomulaLabel.isHidden = true
        fomulaResultLabel.isHidden = true
        exponentLabel.isHidden = true
        
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
            fomulaResultLabel.isHidden = false
            
            if levelChosen == Game.Level.dieHard {
                exponentLabel.isHidden = false
            }
            
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
        case .hard, .dieHard:
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
    
    func showCircleLabel() {
        circleLabel.isHidden = false
        
        circleLabel.text = "✓"
        circleLabel.alpha = 0.6
        circleLabel.font = UIFont.systemFont(ofSize: 400, weight: UIFont.Weight.medium)
        circleLabel.textColor = UIColor.green
        circleLabel.sizeToFit()
        circleLabel.center = self.view.center
        self.view.addSubview(circleLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.circleLabel.alpha = 0.0
        }, completion: nil)
    }
    
    func showCrossLabel() {
        crossLabel.isHidden = false
        
        crossLabel.text = "✕"
        crossLabel.alpha = 0.6
        crossLabel.font = UIFont.systemFont(ofSize: 400, weight: UIFont.Weight.ultraLight)
        crossLabel.textColor = UIColor.red
        crossLabel.sizeToFit()
        crossLabel.center = self.view.center
        self.view.addSubview(crossLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.crossLabel.alpha = 0.0
        }, completion: nil)
    }
}

