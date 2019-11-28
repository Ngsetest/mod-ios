//
//  OrderSummaryPriceTableViewCell.swift
//  Moda
//
//  Created by admin_user on 3/28/19.
//  Copyright © 2019 moda. All rights reserved.
//

import UIKit

class OrderSummaryPriceTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var quantityPriceLabel: UILabel!
    @IBOutlet weak var quantityPrice: UILabel!
    
    @IBOutlet weak var shipmentPriceLabel: UILabel!
    @IBOutlet weak var shipmentPrice: UILabel!
    
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard let order = dataModel as? MyOrderModel else { return }
        
        let delivery_price = Double(getDeliveryPrice(for: order.deliveryType!))
 

        let percentage = ModaManager.shared.appDiscount ?? 0
        let discountedPrice = Double(order.amount! + Double(delivery_price)) * (100 - percentage) / 100
        shipmentPrice.text =  setNiceCurrancy(getDeliveryPrice(for: order.deliveryType!))
        
        discountPrice.text = "\(percentage) %"
        quantityPrice.text = setNiceCurrancy(order.amount!)
        totalPrice.text = setNiceCurrancy(discountedPrice)
 
        
        quantityPriceLabel.text = TR("products_in_genitive") //+ " ( \(order.products.count) )"
        shipmentPriceLabel.text = TR("cost_shipping")
        discountPriceLabel.text = TR("discount_shipping")
        totalPriceLabel.text = TR("total").capitalizingFirstLetter()
        
    }
    
}
