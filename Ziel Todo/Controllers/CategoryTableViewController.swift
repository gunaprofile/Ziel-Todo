//
//  CategoryTableViewController.swift
//  Ziel Todo
//
//  Created by gunm on 14/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//            guard let navBar = navigationController?.navigationBar else{
//                fatalError("Navigation Controller Doesn't exist.")
//            }
//            navBar.barTintColor = UIColor(hexString : "24AEB8" )
//    }
    // MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
     
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        if let colour = UIColor(hexString : categories?[indexPath.row].color ?? "24AEB8")
        {
        cell.backgroundColor = colour
        
        cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
      
        return cell
    
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
    // MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Category"
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Data Manipulation Method
    func save(category : Category){
        
        do{
            
            try realm.write {
                realm.add(category)
            }
        }catch{
            
            print("Error saving context,\(error) ")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory(){
        categories = realm.objects(Category.self)

        tableView.reloadData()

    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: IndexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
            }catch {
                print("Error in deleting category \(error)")
                
            }
        }
    }
}



