//
//  ViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 30/04/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {

    var todoListItems: Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category?{
        didSet{
         loadData()
        }
    }
//    let defualt = UserDefaults.standard
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
      // let request: NSFetchRequest<Items> = Items.fetchRequest()
     //   loadData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell" , for: indexPath)
        if let item = todoListItems?[indexPath.row]{
        cell.textLabel?.text = item.title
             cell.accessoryType = item.done == true ? .checkmark: .none
        }else{
       
            cell.textLabel?.text = "No Item Added"
    
        }
            return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoListItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
                }
            }catch{
                  print("error saving done status \(error)")
                }
            }
        
        tableView.reloadData()
        
        // let rowSelected = itemArray[indexPath.row]
        //print(rowSelected)
//        todoListItems[indexPath.row].done = !todoListItems[indexPath.row].done
//        saveItems()
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
       
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error Saving Items \(error)")
                }
                self.tableView.reloadData()
            }
            
          
           
            
//            self.itemArray.append(newItem)
//           self.saveItems()
            
          
         
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK - Model Manipulation Methods
    
   
    
    func loadData(){
        
        todoListItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

     //   let request: NSFetchRequest<Items> = Items.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate,additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//       // request.predicate = predicate
//            do{
//            itemArray = try context.fetch(request)
//            }catch{
//                print("Error \(error)")
//            }
        }
    
    }
//MARK: - Search methods

extension ToDoListViewController:UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        
        todoListItems = todoListItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        tableView.reloadData()
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
//     let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request, predicate: predicate)
}
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0{
            loadData()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}


