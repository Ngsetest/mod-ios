//
//  OrderInfoTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/18/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class OrderInfoTableViewCell: BaseTableViewCell {
 

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var deliveryType: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date: UILabel!

//    @IBOutlet weak var amountTypeLabel: UILabel!
//    @IBOutlet weak var amountType: UILabel!
    
     @IBOutlet weak var fullLabel: UILabel!
     @IBOutlet weak var full: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        reloadTranslations()
        
    }

    override func reloadTranslations() {
        
        priceLabel.text = TR("payment_amount") + kSemicolons
        deliveryTypeLabel.text = TR("delivery_price_")
        dateLabel.text = TR("delivery_date") 
        fullLabel.text = TR("generally") + kSemicolons
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard let data  = dataModel as? PaymentModel else { return }
 
        price.text = setNiceCurrancy(data.fullPrice!)
        
        let deliveryPrice = getDeliveryPrice(for: data.deliveryType!)
 
        deliveryType.text = setNiceCurrancy(deliveryPrice)
        
        date.text = data.dateLine
        
        let discount = ModaManager.shared.appDiscount ?? 0
        let discountedPrice = Double(data.fullPrice! + deliveryPrice) * (100 - discount) / 100

        full.text = setNiceCurrancy(discountedPrice)
        
        reloadTranslations()
    }
}
