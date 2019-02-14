//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 2/12/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var CategoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       loadCategories()
   
    }
    
    //Mark : Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = CategoryArray[indexPath.row].name
        
       
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selecetedCategory = CategoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return CategoryArray.count
        
    }
    

    
    
    func saveCategories() {
        
        do {
            
            try context.save()
            
        }
        catch {
            
            print("error with saving data \(error)")
            
            
        }
        self.tableView.reloadData()
        
        
    }
    
    func loadCategories () {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            CategoryArray = try context.fetch(request)
        }
        catch {
            print("error with fetching data \(error)")
        }
        
        tableView.reloadData()
        
    }
   

  
    //Mark : Tableview Delegate Methods
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text
            
            
            self.CategoryArray.append(newItem)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Write the category here"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert , animated: true , completion: nil )
        
        
        
        
        
    }
 
}
  



