//
//  ViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 1/31/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {

    
    var itemsArray = [Item]()
    
    var selecetedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
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

        return itemsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
      // Ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
   
        return cell
        
    }
    
    //MARK : TavleView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // context.delete(itemsArray[indexPath.row])
       // itemsArray.remove(at: indexPath.row)
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done


        saveItems()
      
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
       
    }

    //MARK : Add new items
    
    
       
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
           
            // What will happen once the user clicks the add new item button
            
           
            let NewItem = Item(context: self.context)
            
            NewItem.title = textField.text!
            
            NewItem.done = false
            
            NewItem.parentCategory = self.selecetedCategory
            
            self.itemsArray.append(NewItem)
            
            self.saveItems()
            
            print( self.itemsArray.count)

         
            
        }
        alert.addTextField { (AlertTextField) in
            
            AlertTextField.placeholder = "Create a new item"
            
            textField = AlertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
    func saveItems() {
        
        
        do {
            
        try context.save()
            
        }
        catch {
            print("Error with saving items \(error)")
        }
        self.tableView.reloadData()

    }
    
   
    func loadItems (with request : NSFetchRequest <Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selecetedCategory!.name!)

        
        
        if let additionalPredicate = predicate {
            
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
            
        }
        else {
            request.predicate = categoryPredicate
            
        }
        
        
    do {
       itemsArray =  try context.fetch(request)
        
    }
    catch {
    print("error with requesting data \(error)")
    }
        
        tableView.reloadData()
    }
   
    
    }

//MARK: Search-Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        let  request : NSFetchRequest <Item> = Item.fetchRequest()
      
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        
        //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

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
    
    


