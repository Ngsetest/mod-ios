//
//  PeopleInfoStaticTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/18/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class PeopleInfoStaticTableViewCell: BaseTableViewCell {
 
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        reloadTranslations()
    }
    
    override func reloadTranslations() {
        nameLabel.text = TR("customer") + kSemicolons
        emailLabel.text = TR("mail") + kSemicolons
        phoneLabel.text = TR("phone") + kSemicolons
        addressLabel.text = TR("address") + kSemicolons

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard let data  = dataModel as? PaymentModel else { return }
 
        name.text = data.firstName! + " " + data.lastName!
        email.text = data.email
        phone.text = getFormattedPhoneNumber(data.phoneNumber!)
        address.text = data.address
        
        reloadTranslations()

    }
}
