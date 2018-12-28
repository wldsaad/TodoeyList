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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        if let view = Bundle.main.loadNibNamed("CategoryCellXibView", owner: self, options: nil)?.first as? CategoryCustomViewCell {
            xibHolderView.addSubview(view)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
