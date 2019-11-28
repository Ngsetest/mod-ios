//
//  OrderTableViewCell.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 25.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit


class OrderTableViewCell: BaseImageTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!

    @IBOutlet weak var paymentOptionLabel: UILabel!
    @IBOutlet weak var paymentOption: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    var myOrder: MyOrderModel? {
        didSet {
            setUpCellWithOrder(order: myOrder!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCellWithOrder(order: MyOrderModel) {
 
        titleLabel.text = TR("order_num") + "\(order.id)"

        priceLabel.text = TR("lbl_payment_amount") + kSemicolons
        price.text = setNiceCurrancy(order.amount!)
 
        dateLabel.text = TR("date_of_order") + kSemicolons
        date.text = order.createdAt
        
        paymentStatusLabel.text =  TR("lbl_was_payed") + kSemicolons
        paymentStatus.text =  order.prepayment == .full ? TR("yes") :  TR("no")

        paymentOptionLabel.text = TR("lbl_payment_type") + kSemicolons
        paymentOption.text = order.paymentMethod?.rawValue.uppercased()


        statusLabel.text = TR("status_")
        status.text = order.state
        
    }
}
