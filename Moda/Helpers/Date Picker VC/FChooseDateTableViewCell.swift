//
//  FChooseDateTableViewCell.swift
//  Moda
//
//  Created by Alimov Islom on 7/4/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class FChooseDateTableViewCell: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: kFont_normal, size: 18)
        //label.text = "6 июля, пятница"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupAndConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAndConfigure() {
        addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        let divederLine = UIView()
        divederLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divederLine)
        divederLine.backgroundColor = kColor_Gray.withAlphaComponent(0.7)
        divederLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divederLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        divederLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divederLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
}
