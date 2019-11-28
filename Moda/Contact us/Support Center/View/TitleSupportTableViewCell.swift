//
//  TitleSupportTableViewCell.swift
//  Moda
//
//  Created by Alimov Islom on 8/13/18.
//  Copyright © 2018 moda. All rights reserved.
//
import UIKit
class TitleSupportTableViewCell: BaseTableViewCell, ReusableCell {
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var supportTitle: UILabel!
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kColor_LightGray
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.layer.cornerRadius = 5/2
        addSubview(lineView)
        lineView.anchors(bottom: bottomAnchor,
                         left: leftAnchor, leftPadding: 23, right: rightAnchor, rightPadding: 23, height: 1)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
