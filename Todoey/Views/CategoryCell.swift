//
//  CategoryCell.swift
//  Todoey
//
//  Created by Waleed Saad on 12/28/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var xibHolderView: UIView!
    private var categoryView = CategoryCustomViewCell()

    override func awakeFromNib() {
        super.awakeFromNib()
        if let view = Bundle.main.loadNibNamed("CategoryCellXibView", owner: self, options: nil)?.first as? CategoryCustomViewCell {
            categoryView = view
            categoryView.frame = xibHolderView.frame
            xibHolderView.addSubview(categoryView)
        }
    }

    func updatecategoryName(name: String) {
        categoryView.nameLabel.text = name
    }
   

}
