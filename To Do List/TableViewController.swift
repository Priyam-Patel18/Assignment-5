//
//  TableViewController.swift
//  To Do List
//
//  Created by PRIYAM PATEL on 18/02/24.
//

import UIKit

//-----------------------------------Taking a structure for the list items----------------------------------------------------

struct TodoItem: Codable {
    var title: String
}

//--------------------------------------------Main Program--------------------------------------------------------------------
class TableViewController: UITableViewController {

    var taskLists = [TodoItem]()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           loadTodoItems()
       }
       
//----------------------------------------Input Table view data source--------------------------------------------------------
       
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return taskLists.count
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
           let todoItem = taskLists[indexPath.row]
           cell.textLabel?.text = todoItem.title
           return cell
       }
       
    
//-------------------------------------------------Making Add Button Action---------------------------------------------------
       // Add Button Action to call the Method
   
   
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButton(_ sender: UIButton) {
        AddTodoAlert()
    }
    
//----------------------------------------Function to add show alert and take user input--------------------------------------
       
    //Method to add tasks into To-Do Lists
       private func AddTodoAlert() {
           let alertController = UIAlertController(title: "Enter Task", message: nil, preferredStyle: .alert)
           
           alertController.addTextField { textField in
               textField.placeholder = "Task Details"
           }
           
           let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
               if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                   let newTodoItem = TodoItem(title: text)
                   self?.taskLists.append(newTodoItem)
                   self?.saveTodoItems()
                   self?.tableView.reloadData()
               }
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           alertController.addAction(addAction)
           alertController.addAction(cancelAction)
           
           present(alertController, animated: true, completion: nil)
       }
 
//------------------------------------Functions to Save and Retrive the Data--------------------------------------------------
    
    //Using JSONEncoder to save all the task lists
    private func saveTodoItems() {
           let data = try? JSONEncoder().encode(taskLists)
           UserDefaults.standard.set(data, forKey: "todoItems")
       }
        
       
    //Calling saved task lists when reopening the app (load items into the cell)_
       private func loadTodoItems() {
           if let data = UserDefaults.standard.data(forKey: "todoItems"),
              let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
               taskLists = savedTodoItems
           }
       }
       
//---------------------------------------Input Table View Delegate------------------------------------------------------------
    
       //Table View Delegate
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               taskLists.remove(at: indexPath.row)
               saveTodoItems()
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
}
