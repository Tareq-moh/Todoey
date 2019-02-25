//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 2/12/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: SwipeTableTableViewController {

    let realm = try! Realm()
    
    let newItem = Category()
    
    

    
    var categories : Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       loadCategories()
   
    }
    

    //Mark : Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
       

        return cell
        

   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selecetedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return categories?.count ?? 1
        
    }
    

    
    
    func Save(category : Category) {
        
        do {
            try realm.write {
                 realm.add(category)
                
                
            }
        }
        catch {
            
            print("error with saving data \(error)")
        }
                self.tableView.reloadData()
    }
    
    func loadCategories () {
        categories = realm.objects(Category.self).sorted(byKeyPath: "name")
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
       
     
        super.updateModel(at: indexPath)

        if let categoryForDeletion = self.categories?[indexPath.row]
        
        {
            do {
                
               try self.realm.write {
             self.realm.delete(categoryForDeletion)

               super.deleteAllItems(at: indexPath)
                } }

            catch {
                print("error with deleting category \(error)")
            }
        }
    }
   

  
    //Mark : Tableview Delegate Methods
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            if textField.text?.count != 0 {
            
                self.newItem.name = textField.text!
            
            
                self.Save(category: self.newItem)
                
            }
            else {
                print("error with saving an empty srting ")
            }
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Write the category here"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert , animated: true , completion: nil )
        
        
        
        
        
    }
 
}
  

