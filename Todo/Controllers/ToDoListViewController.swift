//
//  ViewController.swift
//  Todo
//
//  Created by Jameel Shehadeh on 02/01/2021.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.placeholder = "asd"
        
        loadData()
    }
    
    //MARK: - add new items

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks the add item button
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveData()
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
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - TableView delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
    
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - save data method
    
    func saveData() {
      
        do {
           
            try context.save()
        }
        catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    //MARK: - load data method
    // READ load using core data
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        // first we create a constant called request and we specify its type as NSFetchRequest that will fetch <Item>
        // then we will tap into our Item class and we are going to make a new fetch request
        // then we have to speak to the context before we can do anything with our persistent container so we use "context.fetch(request)" marked with a try
        // we know that the output of this method is going to be an array of Item that is stored in our persistentContainer so we write "itemArray =  try context.fetch(request)"

        do {
            itemArray =  try context.fetch(request)
        }
        
        catch {
            print("error fetching data from context \(error)")
        }
        
        
    }
    
}

//MARK: - seacrch bar methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        // NSPredicate we initialize it using format the format takes string which is the query
        // we will be looking into the title attribute in each of our items in our itemsArray
        // and see if it CONTAINS a value that we put in the arguments which is searchBar.text!
        // when we hit the search button what ever we have entered inside the search bar
        // is going to be passed in the method NSPredicate
        // after structuring our query we will add our query to our request request.predicate = predicate
        // now after creating our predicate, the next thing is we going to Sort the data we get back
        //from the database in any order of our choice
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key:"title", ascending: true)]
        
        // now we need to run our request and fetch the result
        loadData(with: request)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            tableView.reloadData()
        }
    }
    
}

// encoding and decoding explaination :
// we use the NScoder in order to encode and decode our data to pre specified file path
//and we converted our array of items [CellData] to a plist file that we can save and retrieve from
//

//*1 CREATE core data : first we create a constant called context
// this goes to the app delegate and grabs the persistentContainer and then grab a reference to the context for that persistent container
//let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//*2CREATE when we add a new item to our table view we create object of type Item
// this class "Item" get automatically generated when we create a new entity with that name inside our DataModel
// and that class has access to all the properties that we specified as "Attributes" : "title" and "Done"
// that class "Item" is object of type NSManagedObject
// NSManagedObject are essentially the rows inside your table every single row will be individual NSManagedObject
// and then we fill all of its fields : "title" and "Done" and then we save our items in our temporary
// inside save function we have the method that can throw an error "context.save()" we mark it with try
// it will look into that context "temporary area" which we edited in "let newItem = Item(context: self.context)" which creates an NSManagedObject inside that context
//and then we save the context so we can commit unsaved changes to our persistent store


// READ load using core data
//func loadData() {
// first we create a constant called request and we specify its type as NSFetchRequest that will fetch <Item>
// then we will tap into our Item class and we are going to make a new fetch request
// then we have to speak to the context before we can do anything with our persistent container so we use "context.fetch(request)" marked with a try
// we know that the output of this method is going to be an array of Item that is stored in our persistentContainer so we write "itemArray =  try context.fetch(request)"
//    let request : NSFetchRequest<Item> = Item.fetchRequest()
//    do {
//        itemArray =  try context.fetch(request)
//    }
//
//    catch {
//
//        print("error fetching data from context \(error)")
//    }
//}


// UPDATE in CRUD : itemArray[indexPath.row].setValue("Completed", forKey: "title") this is a managed we can use to update
// we grab the selected object and we can change for example "title" for "Completed" when it is selected

// DELETE in CRUD : itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)



// search bar functionality :
// users will write their word or letters and the tableview will show cells that only contains
// these words or letters
