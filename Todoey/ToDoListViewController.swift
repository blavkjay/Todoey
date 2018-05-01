//
//  ViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 30/04/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["find mike","buy cartons","find demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell" , for: indexPath)
        
        cell.textLabel?.text=itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let rowSelected = itemArray[indexPath.row]
        
        //print(rowSelected)
        
        
       if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
       {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
       }else{
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   

}

