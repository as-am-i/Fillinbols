//
//  Calculation.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-13.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import Foundation

class Calculation {
    
    enum OperatorType: Int {
        case addition = 0
        case substraction = 1
        case multiplication = 2
        case division = 3
        case modulus = 4
    }
    
    let allOperatorTypes = [OperatorType.addition, OperatorType.substraction, OperatorType.multiplication, OperatorType.division, OperatorType.modulus]
    
    // fomula
    private var lhs = 0
    private var rhs = 0
    private var result = 0
    
    var isCorrect = false
    
    init(level: Game.Level) {
        (lhs, rhs, result) = createNewFomula(level: level)
    }
    
    func getFormula() -> String {
        return "\(lhs) ❓ \(rhs) = \(result)"
    }
    
    func calculate(operatorType: OperatorType, num1 :Int, num2: Int) -> Int {
        var result = 0
        
        switch operatorType {
        case .addition:
            result = num1 + num2
        case .substraction:
            result = num1 - num2
        case .multiplication:
            result = num1 * num2
        case .division:
            result = num1 / num2
        case .modulus:
            result = num1 % num2
        }
        return result
    }
    
    func createNewFomula(level: Game.Level) -> (num1: Int, num2: Int, result: Int) {
        
        var n1 : Int
        var n2 : Int
        var result : Int
        
        var range = 4
        
        switch level {
        case .easy:
            range = 2
        case .normal:
            range = 4
        case .hard:
            range = 5
        }

        let index = Int(arc4random_uniform(UInt32(range)))
        let operatorType = allOperatorTypes[index]
        
        if operatorType == .division {
            // n1 must be always n1 * product(result)
            n2 = Int(arc4random_uniform(10)+1) // avoid 0 as diviser
            result = Int(arc4random_uniform(10)+1)
            n1 = n2 * result
        } else if operatorType == .modulus {
            n1 = Int(arc4random_uniform(10))
            n2 = Int(arc4random_uniform(10)+1)
            result = n1 % n2
        } else {
            n1 = Int(arc4random_uniform(10))
            n2 = Int(arc4random_uniform(10))
            result = calculate(operatorType: operatorType, num1: n1, num2: n2)
        }
        
        return (n1, n2, result)
    }
    
    func checkAnswerIsCorrect(choice: OperatorType) {
        isCorrect = false
        if rhs != 0 {
            if result == calculate(operatorType: choice, num1: lhs, num2:rhs) {
                isCorrect = true
            }
        } else {
            if choice != .division && choice != .modulus {
                if result == calculate(operatorType: choice, num1: lhs, num2:rhs) {
                    isCorrect = true
                }
            }
        }
    }
    
    func getFormulaWithOperator(operatorText: String) -> String {
        return "\(lhs) \(operatorText) \(rhs) = \(result)"
    }
}
