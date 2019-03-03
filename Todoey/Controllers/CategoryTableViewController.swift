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
import ChameleonFramework
class CategoryTableViewController: SwipeTableTableViewController {

   // var nn : TodoListViewController = TodoListViewController()
    
    let newItem = Category()

    
    
    let realm = try! Realm()
    
    //let newItem = Category()
    
    

    
    var categories : Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       loadCategories()
        
        tableView.separatorStyle = .none
        
        
   
    }
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "2DC8EE")

    }
    

    //Mark : Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name ?? "No Categories Added yet"
            
            cell.backgroundColor = UIColor(hexString: category.color ?? "2DC8EE")
        }
        
     

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
      //  let mm = nn.selecetedCategory?.items
     
        super.updateModel(at: indexPath)

        if let categoryForDeletion = self.categories?[indexPath.row]
        
        {
            do {
                
               try self.realm.write {
             self.realm.delete(categoryForDeletion)
              // print("items = \(mm)")
               // self.realm.delete(((nn.todoItems)!))
                //self.realm.delete(myCustomViewController.todoItems!)
//               super.deleteAllItems(at: indexPath)
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
            
            let newItem = Category()

                newItem.name = textField.text!
           newItem.color = UIColor.randomFlat.hexValue()
            self.Save(category: newItem)
            
           // self.categories?.realm?.add(self.newItem)
            
           
           
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Write the category here"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert , animated: true , completion: nil )
        
        
        
        
        
    }
 
}
  

