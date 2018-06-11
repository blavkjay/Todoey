//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 05/05/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

   // let realm = try! Realm()
    
    var realm: Realm!
    
    var categoriesArray: Results<Category>?
    

   
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoriesArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoriesArray?[indexPath.row]{
            cell.textLabel!.text =  category.name
            guard let categoryColor = UIColor(hexString: category.colour ) else{fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
       
    //   let colors = categoriesArray?[indexPath.row].colour
        
        
        
        
      //  categoriesArray?[indexPath.row].colour = color
        
        return cell
    }
    
    //MARK: - data manipulation
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadData(){
        
        categoriesArray = realm.objects(Category.self)
        
    }
    
    
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
    if let categoryForDeletion = self.categoriesArray?[indexPath.row]{

        do{
            try  self.realm.write{
                self.realm.delete(categoryForDeletion)
            }
        } catch {
            print("error deleting: \(error)")
    }
        // tableView.reloadData()

    }
        
    }
    
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            let color = UIColor.randomFlat.hexValue()
            newCategory.name = textfield.text!
           newCategory.colour = color
         //   self.categoriesArray.append(newCategory)
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVc.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        loadData()
        tableView.separatorStyle = .none
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

}
}




