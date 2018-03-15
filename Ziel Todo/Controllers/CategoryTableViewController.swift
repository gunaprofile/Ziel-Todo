//
//  CategoryTableViewController.swift
//  Ziel Todo
//
//  Created by gunm on 14/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategory()
        
    }
    // MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let currentCategory = categoryArray[indexPath.row]
        
        cell.textLabel?.text = currentCategory.name
        
        return cell
    
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    // MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
           
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Category"
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Data Manipulation Method
    func saveCategory(){
        
        do{
            
            try context.save()
        }catch{
            
            print("Error saving context,\(error) ")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            
            categoryArray = try context.fetch(request)
            
        }catch{
            
            print("Error saving context,\(error) ")
            
        }
        
        tableView.reloadData()
        
    }
    
    

}
