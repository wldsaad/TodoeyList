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
                let newCategory = Category(context: self.dataContext)
                newCategory.name = name
                self.categories.append(newCategory)
                self.saveData()
                self.tableView.reloadData()
            }
        }
        addAlert.addAction(addAction)
        present(addAlert, animated: true, completion: nil)
    }
    
}

//MARK: - Data Saving and loading into CoreData
extension CategoriesVC {
    
    private func saveData(){
        do {
            try dataContext.save()
        } catch {
            debugPrint("Errod saving: \(error)")
        }
        
    }
    
    private func loadData(){
        let fetchReqest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            self.categories = try dataContext.fetch(fetchReqest)
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
}
