//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by macos on 8/8/18.
//  Copyright © 2018 AnhHD. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var itemArray: Results<ItemModel>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Use "didSet" to specify what should happen when the variable "selectedCategory" gets set with a new value
    var selectedCategory : CategoryModel? {
        didSet {
            loadItemsFromDatabase()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let colorHexCode = selectedCategory?.colorHexCode else { fatalError("Color Hex Code does not exist.") }
     
        updateNavigationBar(withHexCode: colorHexCode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavigationBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - Navigation Bar Setup Methods
    func updateNavigationBar(withHexCode colorHexCode: String) {

        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError("Failed to get Nav Bar color") }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
       // navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath) // Tap into parent SwipeTableViewController
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let cellBackgrounColor = UIColor(hexString: selectedCategory!.colorHexCode)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = cellBackgrounColor
                cell.textLabel?.textColor = ContrastColorOf(cellBackgrounColor, returnFlat: true)
                cell.tintColor = ContrastColorOf(cellBackgrounColor, returnFlat: true) // Checkmark color
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done // Toggle item check mark
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (uiAlertAction) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = ItemModel()
                        newItem.title = newItemTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            // Must use the "self" keyword in a closure
            self.tableView.reloadData()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            newItemTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Model manipulation methods

    func loadItemsFromDatabase() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
            try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}

// Use "extension" to separate out bits of functionality inside the ViewController
extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }

    // When user cancels search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItemsFromDatabase()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

