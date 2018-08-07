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
    var games = [Game]()
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showFinalScore()
        askUserName()
        if (game.isFinished == true) {
            saveContext()
        }
    }
    
    private func showFinalScore() {
        finalScoreLabel.text = "\(finalScore)"
        levelLabel.text = "Level: \(level)"
    }
    
    private func getAllResults() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let filter = game.level
        fetchRequest.predicate = NSPredicate(format: "level = %@", filter!)
        
        let sort = NSSortDescriptor(key: #keyPath(Game.score), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        // only top 5
        fetchRequest.fetchLimit = 5
        do {
            games = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func askUserName() {
        getAllResults()
        
        if games.count < 5 || game.score >= games[4].score {
            showInputDialog()
        }
    }
    
    private func showInputDialog() {
        // create an alert controller
        let alertController = UIAlertController(title: "Got a high score! Keep it in the rank!", message: "Enter your name.\n('John Smith' would be your name if no name provided.\nCancel if you don't need this game result)", preferredStyle: .alert)
        
        // create actions: confirm and cancel
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            let textField = alertController.textFields![0].text
            if (!(textField!.isEmpty)) {
                self.game.name = textField
            } else {
                self.game.name = "John Smith"
            }
            self.saveContext() // save context immediately after naming
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.managedObjectContext.delete(self.game)
        }
        
        // placeholder
        alertController.addTextField {(textField) in textField.placeholder = "Enter Name"}
        
        // add actions
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // present the dialog
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Segue
    @IBAction func callSegue(_ sender: UIButton) {
        // move to rank view
        performSegue(withIdentifier: "toRankView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRankView" {
            if let destination = segue.destination as? RankViewController {
                destination.managedObjectContext = managedObjectContext
            }
        } else if segue.identifier == "toLevelChoice" {
            if let navController = segue.destination as? UINavigationController {
                let navViewControllers = navController.viewControllers // navViewControllers == array of all the viewControllers
                if let destination = navViewControllers.first as? LevelChoiceViewController {
                    destination.managedObjectContext = managedObjectContext
                }
            }
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
