//
//  HeaderCollectionProductsTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/25/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class HeaderCollectionProductsTableViewCell: BaseTableViewCell {

    @IBOutlet var button : UIButton!
    
    // MARK: - Outlets

    @IBOutlet weak var headerTitle: UILabel! {
        didSet {
            headerTitle.sizeToFit()
            button.setTitle(" ", for: .normal)
//            button.setTitle(TR("see_all"), for: .normal)
        }
    }

    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        headerTitle.text = nil

        super.prepareForReuse()
    }
    
    
    @IBAction func onSeeAll(){
        
    }
}
