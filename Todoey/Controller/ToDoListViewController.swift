//
//  ViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 30/04/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var todoListItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
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
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  tableView.separatorStyle = .none
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            title = selectedCategory?.name
           guard let colorHex = selectedCategory?.colour else {fatalError()}
       
        updateNavBar(withHexCode: colorHex)
            
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar Setup method
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller doesnt exist")}
     
        guard let navBarColor = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        if let item = todoListItems?[indexPath.row]{
        cell.textLabel?.text = item.title
            let color = selectedCategory?.colour
            if let colour = UIColor(hexString: color!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoListItems!.count)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
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
    
    
    // MARK: - Delete from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        
        if let itemForDeletion = self.todoListItems?[indexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("error deleting item \(error)")
            }
            
        }
        
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


