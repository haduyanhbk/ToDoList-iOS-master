//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by macos on 8/8/18.
//  Copyright © 2018 AnhHD. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<CategoryModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoriesFromDatabase()
        
        tableView.separatorStyle = .none // Separator between cells.  None = no line between cells
    }

    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1 // Return 1 row if category array is nil, using Nil Coalescing Operator "??"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath) // Tap into parent SwipeTableViewController
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.colorHexCode) else { fatalError("Category Color error!") }
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods

    func saveItemsToDatabase(category: CategoryModel) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoriesFromDatabase() {

        categoryArray = realm.objects(CategoryModel.self)

        tableView.reloadData()
    }

    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categotyMarkedForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categotyMarkedForDeletion)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
    }
    
    // MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (uiAlertAction) in
            if (newCategoryTextField.text != nil) {
                let newCategory = CategoryModel()
                newCategory.name = newCategoryTextField.text!
                newCategory.colorHexCode = UIColor.randomFlat.hexValue()
                self.saveItemsToDatabase(category: newCategory)
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Ooops!!!", message: "Please enter text to save task", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new category"
            newCategoryTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
