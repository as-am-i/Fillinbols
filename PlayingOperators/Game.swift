//
//  Game.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-14.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import Foundation

class Game {
    
    private(set) var scoreCount = 0
    private var isFinished = false
    let level : Level
    var calculations = [Calculation]()
    
    enum Level : String {
        case easy = "EASY"
        case normal = "NORMAL"
        case hard = "HARD"
    }
    
    init(gameLevel: Level) {
        scoreCount = 0
        isFinished = false
        level = gameLevel
        setUpCalulations()
    }
    
    func setUpCalulations(){
        for _ in 1...10 {
            let calculation = Calculation()
            calculations.append(calculation)
        }
    }
    
    func getScoreCount() -> String {
        return "Score: \(scoreCount)"
    }
    
    func getLevel() -> String {
        return "\(level.rawValue)"
    }
    
    func getCalculation(index: Int) -> Calculation {
        return calculations[index]
    }
    
}
