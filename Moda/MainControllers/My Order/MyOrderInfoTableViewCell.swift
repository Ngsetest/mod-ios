//
//  MyOrderInfoTableViewCell.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 26.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class MyOrderInfoTableViewCell: BaseImageTableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var quantityLabelName: UILabel!
    @IBOutlet weak var sizeLabelName: UILabel!
    @IBOutlet weak var colorLabelName: UILabel!

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    
    var myOrder: MyOrderProduct? {
        didSet {
            self.setUpCellWithData(myOrder!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        reloadTranslations()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func reloadTranslations() {
        
        quantityLabelName.text = TR("quantity")
        sizeLabel.text = TR("size")
        colorLabel.text = TR("color")
        
    }
    
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard  let order = dataModel as? MyOrderProduct else { return }
  
        loadImage(order.existing.image.url)
        
        let brand: String = order.existing.brand.name
        brandLabel.text = brand
        typeLabel.text = order.name
        sizeLabel.text = order.size
        idLabel.text = " "//"# \(order.existing.sku ?? kEmpty)"
        colorLabel.text = order.color
        quantityLabel.text = "\(order.quantity) " + TR("pcs")
        
        
        let discount = order.existing.discount ?? ModaManager.shared.appDiscount ?? 0
    
        if discount > 0 {
            
            oldPriceLabel.isHidden = false
            discountPriceLabel.isHidden = false

            let attributes = [
                NSAttributedStringKey.font: UIFont(name: kFont_medium, size: 14)!,
                NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)
            ]
            
            let labelText = setNiceCurrancy(order.price!)
            oldPriceLabel.attributedText = NSAttributedString(string: labelText, attributes: attributes)
            discountPriceLabel.text = setNiceCurrancy(discount)
            
        } else {
            
            discountPriceLabel.isHidden = true
            discountPriceLabel.text = kEmpty
            oldPriceLabel.font = UIFont(name: kFont_medium, size: 14)
            oldPriceLabel.text = setNiceCurrancy(order.price!)
        }
        
    }
    
}
