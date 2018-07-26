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
    
    var finalScore = 0
    var level = ""
    var game : Game!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var rank = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self // delegate is who is implementing the protocol
        tableView.dataSource = self

        setupTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllResult()
    }
    
    func setupTodos() {
        let game = Game(context: managedObjectContext)
        game.level = level
        game.score = Int32(finalScore)
        
        saveContext()
        loadAllResult()
    }
    
    // MARK: CoreData
    fileprivate func loadAllResult() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Game.score), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            rank = try managedObjectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func saveContext() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension RankViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankTableViewCell
        let result = rank[indexPath.row]

        cell.update(with: result, index: indexPath)
        return cell
    }
}
