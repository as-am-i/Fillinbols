//
//  RankViewController.swift
//  PlayingOperators
//
//  Created by 谷井朝美 on 2018-07-25.
//  Copyright © 2018 Asami Tanii. All rights reserved.
//

import UIKit
import CoreData

class RankViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var sections = [String]()
    var gameResults = [[Game]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self // delegate is who is implementing the protocol
        tableView.dataSource = self

        loadAllResult()
    }
    
    
    // MARK: CoreData
    fileprivate func loadAllResult() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        // game results
        for level in Game.allLevels {
            // append section one after one game
            // I need to have section and result at the same pace
            sections.append(level.rawValue)
            
            let filter = level.rawValue
            fetchRequest.predicate = NSPredicate(format: "level = %@", filter)

            let sort = NSSortDescriptor(key: #keyPath(Game.score), ascending: false)
            fetchRequest.sortDescriptors = [sort]

            // only top 5
            fetchRequest.fetchLimit = 5

            do {
                let result = try managedObjectContext.fetch(fetchRequest)
                gameResults.append(result)
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
}

extension RankViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameResults[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // indexPath == index of sections
        // indexPath.row = index of cell in each section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankTableViewCell
        let result = gameResults[indexPath.section][indexPath.row]

        cell.update(with: result, index: indexPath)
        return cell
    }
}
