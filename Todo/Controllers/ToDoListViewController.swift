//
//  ViewController.swift
//  Todo
//
//  Created by Jameel Shehadeh on 02/01/2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    

    
    
    var itemArray = [CellData]()
    
    
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let item = defaults.array(forKey: "ToDoListArray") as? [String]  {
//            itemArray = item
//        }
        
        let newItem = CellData()
        newItem.data = "hello"
        itemArray.append(newItem)
        
        
        let newItem2 = CellData()
        newItem2.data = "whats app"
        itemArray.append(newItem2)
        
        let newItem3 = CellData()
        newItem3.data = "yes"
        itemArray.append(newItem3)
    
    }

    
    
    
    //MARK: - add new items
    

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks the add item button
            let newItem = CellData()
            newItem.data = textField.text!
            self.itemArray.append(newItem)
//            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write item name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
    //MARK: - Tableview datasource method
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.data
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == false {
//            cell.accessoryType = .none
//        }
//        else {
//            cell.accessoryType = .checkmark
//        }
//
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //the above line replaces the if statment sets the property reverse to what it was
//        if itemArray[indexPath.row].done == true {
//            itemArray[indexPath.row].done = false
//        }
//        else
//        {
//            itemArray[indexPath.row].done = true
//        }
//
        tableView.reloadData()
        
        
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else
//        {
//
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
      
        
    }
    

}

