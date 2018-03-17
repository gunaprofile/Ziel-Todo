//
//  ViewController.swift
//  Ziel Todo
//
//  Created by gunm on 12/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
            
            loadItem()
            
        }
        
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = (selectedCategory?.color) else{ fatalError()}
        updateNavBar(withHexCode: colorHex)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        updateNavBar(withHexCode: "0080FF")
//    }
    override func willMove(toParentViewController parent: UIViewController?) {
        updateNavBar(withHexCode: "0080FF")
    }

    // MARK: - Navbar Method
    func updateNavBar(withHexCode colorHexCode : String){
        
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation Controller Doesn't exist.")
        }
        guard let navBarColor = UIColor(hexString : colorHexCode) else{ fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf( navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf( navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
        
    }
    // MARK: - Table View Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let currentItem = todoItems?[indexPath.row]{
        
            cell.textLabel?.text = currentItem.title
            
            if let colour = UIColor(hexString : (selectedCategory?.color)!)?.darken(byPercentage: CGFloat( CGFloat(indexPath.row) / CGFloat(todoItems!.count))){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.accessoryType = currentItem.done ? .checkmark : .none
            }
            
        }else{
            cell.textLabel?.text = "No Item added!"
        }
        
        return cell
    }
    
    // MARK: - Table View Deletegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error in updating item, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
       let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
              //  if(textField.text?.isEmpty ?? false){
                    do {
                        try self.realm.write {
                            let newItem = Item()
        
                            newItem.title = textField.text!
                            
                            newItem.dateCreated = Date()
        
                            currentCategory.items.append(newItem)
                        }
                        
                    }catch {
                        print("Error on add new item \(error)")
                        
                    }
               // }
            }
             self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item in  ..."
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadItem(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()

    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: IndexPath)
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
                
            }catch {
                print("Error in deleting item \(error)")
                
            }
        }
    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    
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

