//
//  ButtonSupportTableViewCell.swift
//  Moda
//
//  Created by Alimov Islom on 8/13/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class ButtonSupportTableViewCell: BaseTableViewCell, ReusableCell {
    
    @IBOutlet weak var supportButton: UIButton!
    let imageIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "supprotMail")
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        supportButton.addSubview(imageIconView)
        imageIconView.anchors(left: supportButton.leftAnchor, leftPadding: 32,  width: 42, height: 42,  centerY: centerYAnchor )
        supportButton.layer.borderWidth = 1
        supportButton.layer.borderColor = kColor_AppGrayishOrange.cgColor
        supportButton.setTitle(TR("write_us"), for: .normal)
        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
