//
//  ItemColorTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/21/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import UIKit

class ItemColorTableViewCell: BaseTableViewCell {
 

    @IBOutlet weak var color: UIView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        color.layer.cornerRadius = 12.5
        color.layer.borderWidth = 1.5
        color.layer.borderColor =  kColor_Gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
