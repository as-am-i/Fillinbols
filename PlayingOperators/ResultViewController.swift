//
//  ResultViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-18.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {
    
    // MARK: Properties
    var finalScore = 0
    var level = ""
    var game : Game!
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showFinalScore()
    }
    
    private func showFinalScore() {
        finalScoreLabel.text = "\(finalScore)"
        levelLabel.text = "Level: \(level)"
    }
    
    // MARK: Segue
    @IBAction func callSegue(_ sender: UIButton) {
        // move to rank view
        performSegue(withIdentifier: "toRankView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRankView" {
            if let destination = segue.destination as? RankViewController {
                destination.finalScore = finalScore
                destination.level = level
                destination.game = game
                destination.managedObjectContext = managedObjectContext
            }
        }
    }
}
