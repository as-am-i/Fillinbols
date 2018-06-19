//
//  ResultViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-06-18.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: Properties
    var finalScore = 0
    var level = ""
    
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
}
