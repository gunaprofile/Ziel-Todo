//
//  ViewController.swift
//  Ziel Todo
//
//  Created by gunm on 12/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet{
            
              loadItem()
            
        }
        
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    // MARK: - Table View Datasource Method
    
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
    
    // MARK: - Table View Deletegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //*** Update Item
       // itemArray[indexPath.row].setValue(itemArray[indexPath.row].title, forKey: "title")
        
 //       ** Delete Item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
     
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item in \(self.selectedCategory!.name!) ..."
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        
        do{
            
            try context.save()
        }catch{
            
            print("Error saving context,\(error) ")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
             request.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
            
        }catch{
            
            print("Error saving context,\(error) ")
            
        }
        
        tableView.reloadData()
            
    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        //Search Request
            let request : NSFetchRequest<Item> = Item.fetchRequest()
        
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        //Sort Request
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
            request.sortDescriptors = [sortDescriptors]
        
        //Fetch Request
        
        loadItem(with : request, predicate : predicate)
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            loadItem()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        }
        
    }
    
}
