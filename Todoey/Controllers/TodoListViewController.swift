//
//  ViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 1/31/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selecetedCategory : Category? {
        didSet{
           loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        
       // if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
       //   itemsArray = items
       // }

        
        }


   

    //MARK - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
      // Ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added"
        }
   
        return cell
        
    }
    
    //MARK : TavleView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
           item.done = !item.done
                   //print(item.date)
                }}
            catch {
                print("error with checking the items \(error)")
            }
        }
        
        tableView.reloadData()
        
      
      
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
       
    }

    //MARK : Add new items
    
    
       
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
           
            // What will happen once the user clicks the add new item button
            if let currentCtegory = self.selecetedCategory {
                
                do {
                    try self.realm.write {
                    let NewItem = Item()
                    NewItem.title = textField.text!
                        NewItem.date = Date()
                        
                    currentCtegory.items.append(NewItem)
                    }}
                    catch {
                    print("error with saving data \(error)")
                    
                }
            }
        self.tableView.reloadData()
          
         
        }
        alert.addTextField { (AlertTextField) in
            
            AlertTextField.placeholder = "Create a new item"
            
            textField = AlertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
   
    
   
    func loadItems () {

        todoItems = selecetedCategory?.items.sorted(byKeyPath: "date", ascending: false)
        

        tableView.reloadData()
    }
   
    
    }

//MARK: Search-Bar Methods

extension TodoListViewController : UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@" ,searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}




