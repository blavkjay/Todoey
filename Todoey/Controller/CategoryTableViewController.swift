//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by JAY BLACK on 05/05/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoriesArray = [Category]()
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoriesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoriesArray[indexPath.row]
        cell.textLabel!.text = category.name
        return cell
    }
    
    //MARK: - data manipulation
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("error: \(error)")
        }
        self.tableView.reloadData()
    }
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print("error:\(error)")
        }
        
    }
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            self.categoriesArray.append(newCategory)
            self.saveCategory()
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
            destinationVc.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

  

}
