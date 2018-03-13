//
//  ViewController.swift
//  Ziel Todo
//
//  Created by gunm on 12/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Raise PR for Bug ID"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title =  "DO code clean"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Compoenent changes for DNAC"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Do DNAC Setup"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{

            itemArray = items

        }
    }
    
    // MARK - Table View Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        
        cell.accessoryType = currentItem.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - Table View Deletegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen when user clicks the add item button on UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

}

