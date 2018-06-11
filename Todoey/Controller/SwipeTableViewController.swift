//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by OLAJUWON on 6/11/18.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
tableView.rowHeight = 80.0
        
    }

   // MARK: -Table Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
       
       cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //            self.categoryArray.remove(at: indexPath.row)
            //            action.fulfill(with: .delete)
            
            
           self.updateModel(at: indexPath)
            

            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash Icon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        
    }
}
