//
//  ViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 30/04/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Items]()
    
    let defualt = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Items()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Items()
        newItem2.title = "moyin the bad guy"
        itemArray.append(newItem2)
        let newItem3 = Items()
        newItem3.title = "yoyo bitters"
        itemArray.append(newItem3)
        // Do any additional setup after loading the view, typically from a nib.
      if let  items = defualt.array(forKey: "TodoListArray") as? [Items]{
            itemArray = items
        }
    }
    
    //MARK - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell" , for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark: .none
        
       
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let rowSelected = itemArray[indexPath.row]
        
        //print(rowSelected)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
//       if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//       {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//       }else{
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.reloadData()
        
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
            
            let newItem = Items()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
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

