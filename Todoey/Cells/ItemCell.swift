//
//  ItemCell.swift
//  Todoey
//
//  Created by Waleed Saad on 12/28/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    private var itemView = ItemCustomViewCell()

    @IBOutlet weak var xibViewHolder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        if let view = Bundle.main.loadNibNamed("ItemCellXibView", owner: self, options: nil)?.first as? ItemCustomViewCell {
            itemView = view
            itemView.frame = xibViewHolder.frame
            xibViewHolder.addSubview(itemView)
        }
    }
    
    func updateTodoNames(withName todo: String) {
        itemView.nameLabel.text = todo
    }
    
}
