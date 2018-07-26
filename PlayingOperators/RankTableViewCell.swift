//
//  RankTableViewCell.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-07-26.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    func update(with result: Game, index: IndexPath) {
        rankLabel.text = String(format: "%d", index.row + 1)
        scoreLabel.text = "\(result.score)"
        userNameLabel.text = result.name
        levelLabel.text = result.level
    }

}
