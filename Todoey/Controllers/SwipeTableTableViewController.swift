//
//  SwipeTableTableViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 2/21/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableTableViewController: UITableViewController, SwipeTableViewCellDelegate{
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
                cell.delegate = self
        


                return cell
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion

            self.updateModel(at: indexPath)
            self.deleteAllItems(at: indexPath)
            //self.updateCheckingCell(at: indexPath)
            
        }
        
        
        deleteAction.image = UIImage(named: "TrashIcon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(at indexPath : IndexPath) {
        
        print("item deleted from category list")
    }
    
 
    
   
    
    //MARK : THE SELECTING ITEMS FROM TODO LIST -----------------------------------------------------
    
    func deleteAllItems(at indexPath : IndexPath) {
        
        print("items has been deleted from delete all items method")
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.updateCheckingCell(at: indexPath)
        

        
      
        
    }
    
    func updateCheckingCell(at indexPath : IndexPath) {
        
    }
}
