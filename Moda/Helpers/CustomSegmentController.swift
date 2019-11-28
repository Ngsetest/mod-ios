//
//  CustomSegmentController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/24/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

extension UIView {
    func customize(
        segmentedControl: UISegmentedControl,
        with buttonBar: UIButton,
        and constraints: inout [NSLayoutConstraint]
    ) {
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: kFont_normal, size: 11)!,
            NSAttributedStringKey.foregroundColor: kColor_LightGray
        ], for: .normal
        )
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: kFont_medium, size: 11)!,
            NSAttributedStringKey.foregroundColor: kColor_AppBlack
        ], for: .selected
        )
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = kColor_AppBlack
        
        self.addSubview(buttonBar)
        
        constraints += [
            buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            buttonBar.heightAnchor.constraint(equalToConstant: 1),
            buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor),
            buttonBar.widthAnchor.constraint(
                equalTo: segmentedControl.widthAnchor,
                multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)
            )
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
