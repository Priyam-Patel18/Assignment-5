//
//  TableViewController.swift
//  To Do List
//
//  Created by PRIYAM PATEL on 18/02/24.
//

import UIKit

struct TodoItem: Codable {
    var title: String
}

class TableViewController: UITableViewController {

    var todoItems = [TodoItem]()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           loadTodoItems()
       }
       
       // MARK: - Table view data source
       
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return todoItems.count
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
           let todoItem = todoItems[indexPath.row]
           cell.textLabel?.text = todoItem.title
           return cell
       }
       
       // MARK: - Actions
   
   
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButton(_ sender: UIButton) {
        showAddTodoAlert()
    }
    
    /*@IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAddTodoAlert()
       }*/
       
       // MARK: - Private Methods
       
       private func showAddTodoAlert() {
           let alertController = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
           
           alertController.addTextField { textField in
               textField.placeholder = "Enter todo item"
           }
           
           let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
               if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                   let newTodoItem = TodoItem(title: text)
                   self?.todoItems.append(newTodoItem)
                   self?.saveTodoItems()
                   self?.tableView.reloadData()
               }
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           alertController.addAction(addAction)
           alertController.addAction(cancelAction)
           
           present(alertController, animated: true, completion: nil)
       }
       
        private func saveTodoItems() {
           // Implement data persistence to save todoItems
           // For example, you can use UserDefaults or Core Data
           // UserDefaults is used in this example for simplicity
           let data = try? JSONEncoder().encode(todoItems)
           UserDefaults.standard.set(data, forKey: "todoItems")
       }
        
       
       private func loadTodoItems() {
           // Load todoItems from data persistence
           if let data = UserDefaults.standard.data(forKey: "todoItems"),
              let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
               todoItems = savedTodoItems
           }
       }
       
       // MARK: - Table view delegate
       
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               todoItems.remove(at: indexPath.row)
               saveTodoItems()
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
}
