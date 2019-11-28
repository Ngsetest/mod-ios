//
//  TableViewCell.swift
//  Moda
//
//  Created by Alimov Islom on 8/12/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class ImageSupportTableViewCell: BaseTableViewCell, ReusableCell {
    
    @IBOutlet weak var greyBackgroundView: UIView!
    @IBOutlet weak var supportTitle: UILabel!
    @IBOutlet weak var supportImage: UIImageView!
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kColor_LightGray
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        greyBackgroundView.layer.cornerRadius = 80/2
        addSubview(lineView)
        lineView.anchors(bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
