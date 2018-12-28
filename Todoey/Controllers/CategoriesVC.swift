//
//  ViewController.swift
//  Todoey
//
//  Created by Waleed Saad on 12/28/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import CoreData

class CategoriesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var categories = [Category]()
    
    @IBOutlet weak var hideViews: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }

    @IBAction func addNewCategoryAction(_ sender: UIBarButtonItem) {
        var addTextField = UITextField()
        let addAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        addAlert.addTextField { (textField) in
            addTextField = textField
            addTextField.placeholder = "Type a new category"
        }
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let name = addTextField.text {
                if name.count > 0 {
                    let newCategory = Category(context: self.dataContext)
                    newCategory.name = name
                    self.categories.append(newCategory)
                    self.saveData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            addAlert.dismiss(animated: true, completion: nil)
        }
        addAlert.addAction(addAction)
        addAlert.addAction(cancelAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    private func showOrHideViews(){
        hideViews.isHidden = categories.count > 0 ? true : false
        tableView.isHidden = categories.count > 0 ? false : true
    }
}

//MARK: - Data Saving and loading into CoreData
extension CategoriesVC {
    
    private func saveData(){
        do {
            try dataContext.save()
            tableView.reloadData()
            showOrHideViews()
        } catch {
            debugPrint("Errod saving: \(error)")
        }
        
    }
    
    private func loadData(){
        let fetchReqest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            self.categories = try dataContext.fetch(fetchReqest)
            tableView.reloadData()
            showOrHideViews()
        } catch {
            debugPrint("Error loading: \(error)")
        }
    }
}


//MARK: - Extension for TableView DataSource
extension CategoriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            if let categoryName = categories[indexPath.row].name {
                cell.updatecategoryName(name: categoryName)
            }
            return cell
        }
        
        return CategoryCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataContext.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveData()
        }
    }
}

//MARK: - Extension for TableView Delegate
extension CategoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let categorySelected = categories[indexPath.row]
        performSegue(withIdentifier: "showItemsSegue", sender: categorySelected)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemsVC = segue.destination as? ItemsVC {
            itemsVC.updatedCurrentCategory(forCategory: sender as! Category)
        }
    }
}
