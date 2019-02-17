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
class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       loadCategories()
   
    }
    
    func loadCategories () {
        
         categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //Mark : Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
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
    
   
   

  
    //Mark : Tableview Delegate Methods
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem = Category()
            
            if textField.text?.count != 0 {
            
            newItem.name = textField.text!
            
            
            
            self.Save(category: newItem)
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
  



