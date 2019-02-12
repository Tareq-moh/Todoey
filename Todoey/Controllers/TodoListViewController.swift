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
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        
       // if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
       //   itemsArray = items
       // }

        loadItems()
        
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
    
   
    func loadItems ( ) {
        let  request : NSFetchRequest <Item> = Item.fetchRequest()

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
      
        print("///////////////")

        print(itemsArray)

        print("///////////////")

        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDiscreptor = NSSortDescriptor(key: "title ", ascending: true)
        
        request.sortDescriptors = [sortDiscreptor]
        
        print(request)
        do {
            
            itemsArray =  try context.fetch(request)
            
        }
       catch {
            
            print("error with fetching data from context \(error)")
        } 
        
tableView.reloadData()
    }
    
}
    
    


