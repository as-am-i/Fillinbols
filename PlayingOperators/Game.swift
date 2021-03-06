//
//  Game.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-14.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import Foundation
import CoreData

@objc(Game)
class Game: NSManagedObject {
    
//    var managedObjectContext: NSManagedObjectContext!
//    No need to declare managedObjectContext in Game Model because the Model extends NSManagedObject (parent of NSManagedObjectContext)
    var calculationsArray = [Calculation]()

    enum Level : String {
        case easy = "EASY"
        case normal = "NORMAL"
        case hard = "HARD"
        case dieHard = "DIE HARD"
    }
    
    static let allLevels = [Level.easy, Level.normal, Level.hard, Level.dieHard]
    
    func setupGameProperties(gameLevel: Level) {
        self.score = 0
        self.name = "John Smith"
        self.isFinished = false
        self.level = gameLevel.rawValue
        setUpCalulations(gamelevel: gameLevel)
        setupTimeForCalculation(gameLevel: gameLevel)
    }
    
    func setUpCalulations(gamelevel: Level){
        for _ in 1...10 {
            let calculation = Calculation(context: managedObjectContext!)
            calculation.setupCalculationProperties(gameLevel: gamelevel)
            
            self.calculations?.adding(calculation) // self.calculations == relationship on CoreData, and relationship always works with Set
            self.calculationsArray.append(calculation)
        }
    }
    
    func setupTimeForCalculation(gameLevel: Level) {
        switch gameLevel {
        case .easy:
            self.calc_time = 3
        case .normal:
            self.calc_time = 5
        case .hard:
            self.calc_time = 7
        case .dieHard:
            self.calc_time = 8
        }
    }
    
    func getScoreCount() -> String {
        return "Score: \(score)"
    }
    
    func getLevel() -> String {
        return self.level!
    }
    
    func getCalculationTimeAsInt() -> Int {
        return Int(self.calc_time)
    }
    
    func getCalculationTimeAsString() -> String {
        return "Time: \(self.calc_time)"
    }
    
    func getCalculationIndex(currentIndexOfCalcultion: Int) -> String {
        if currentIndexOfCalcultion != 9 {
            let number = currentIndexOfCalcultion + 1
            return "No.\(number)"
        } else {
            return "LAST"
        }

    }
    
    func getLevelValue() -> Level {
        return Game.Level(rawValue: self.level!)!
    }
    
    func getCalculation(index: Int) -> Calculation {
        return calculationsArray[index]
    }
    
    func calculateScore(currentIndexOfCalculation: Int, score: Int) {
        if calculationsArray[currentIndexOfCalculation].isCorrect {
            self.score = self.score + Int32(score)
        } else {
            self.score -= 1
        }
    }
    
    func checkGameFinished() -> Bool {
        return self.isFinished ? true : false
    }
    
    func setGameFinished() {
        self.isFinished = true
    }
    
}
