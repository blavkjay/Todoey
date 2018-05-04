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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let defualt = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
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
        saveItems()
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
        
     //   tableView.reloadData()
        
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
            self.saveItems()
          //  self.defualt.set(self.itemArray, forKey: "TodoListArray")
            
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
    //MARK - Model Manipulation Methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
            itemArray = try decoder.decode([Items].self, from: data)
            }catch{
                print("Error \(error)")
            }
        }
        
    }

}

