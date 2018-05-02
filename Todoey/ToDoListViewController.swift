//
//  ViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 30/04/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["find mike","buy cartons","find demogorgon"]
    
    let defualt = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      if let  items = defualt.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
   //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
       
            //    let NewItem = alert.textFields? as UITextField
            //itemArray.append(NewItem.text)
            //if textField.text! != ""{
            self.itemArray.append(textField.text!)
            self.defualt.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
           // }else{
                
           // }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

