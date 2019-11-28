//
//  DeliveryTableViewCell.swift
//  Moda
//
//  Created by Alimov Islom on 7/5/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit



class DeliveryTableViewCell: BaseTableViewCell {
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "right-chevron"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: kFont_normal , size: 16)
        label.text = TR("choose_date")
        label.textAlignment = .left
        label.textColor = kColor_Gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: kFont_medium, size: 20)
        //label.text = "6 июля, пятница"
        label.textAlignment = .left
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
        addSubview(arrowImageView)
        arrowImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        addSubview(titleHeader)
        titleHeader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleHeader.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        titleHeader.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 8).isActive = true
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

