//
//  ItemsVC.swift
//  Todoey
//
//  Created by Waleed Saad on 12/28/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import CoreData

class ItemsVC: UIViewController {

    
    private var selectedCategory: Category?
    private var items = [Items]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hideViews: UIView!
    private lazy var overlayView = UIView()
    private let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissGesture()

    }
    
    private func addDismissGesture(){
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(dismissTap)
    }
    
    @objc private func dismissKeyboard(){
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    
    func updatedCurrentCategory(forCategory categroy: Category){
        self.selectedCategory = categroy
        self.navigationItem.title = categroy.name
        loadItems(parentCategory: categroy)
    }
    
    private func loadItems(parentCategory categoy: Category){
        let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
        if let categoryName = categoy.name {
            fetchRequest.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        }
        do {
            self.items = try dataContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showOrHideViews()
            }
        } catch {
            debugPrint("Error loading items: \(error)")
        }
    }
    
    @IBAction func addNewItemAction(_ sender: UIBarButtonItem) {
        var addTextField = UITextField()
        let addAlert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        addAlert.addTextField { (textField) in
            addTextField = textField
            addTextField.placeholder = "Type a new todo"
        }
        let addAction = UIAlertAction(title: "Add Todo", style: .default) { (action) in
            if let name = addTextField.text {
                if name.count > 0 {
                    let newItem = Items(context: self.dataContext)
                    newItem.name = name
                    newItem.checked = false
                    newItem.parentCategory = self.selectedCategory
                    self.items.append(newItem)
                    self.saveData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            addAlert.dismiss(animated: true, completion: nil)
        }
        addAlert.addAction(cancelAction)
        addAlert.addAction(addAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    private func saveData(){
        do {
            try dataContext.save()
            tableView.reloadData()
            showOrHideViews()
        } catch {
            debugPrint("Errod saving: \(error)")
        }
        
    }
    
    private func showOrHideViews(){
        hideViews.isHidden = items.count > 0 ? true : false
        tableView.isHidden = items.count > 0 ? false : true
    }
    
}
//MARK: - Extension for TableView DataSource
extension ItemsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell {
            if let todoName = items[indexPath.row].name {
                cell.updateTodoNames(withName: todoName)
            }
            cell.accessoryType = items[indexPath.row].checked ? .checkmark : .none
            return cell
        }
        
        return ItemCell()
    }
}

//MARK: - Extension for TableView Delegate
extension ItemsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].checked = !items[indexPath.row].checked
        saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataContext.delete(items[indexPath.row])
            items.remove(at: indexPath.row)
            saveData()
        }
    }
}

//MARK: - Extension for Searchbar
extension ItemsVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        overlayView.frame = view.frame
        view.addSubview(overlayView)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        overlayView.removeFromSuperview()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            if let selectedCategory = selectedCategory {
                loadItems(parentCategory: selectedCategory)
            }
        } else {
            let filterRequest: NSFetchRequest<Items> = Items.fetchRequest()
            if let categoryName = selectedCategory?.name {
                let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
                let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
                let compoundPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
                filterRequest.predicate = compoundPredicates
                do {
                    self.items = try self.dataContext.fetch(filterRequest)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    
                }
            }
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

