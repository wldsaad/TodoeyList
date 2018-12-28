//
//  ViewController.swift
//  Todoey
//
//  Created by Waleed Saad on 12/28/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension CategoriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            return cell
        }
        
        return CategoryCell()
    }
}
