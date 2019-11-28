//
//  ShoppingBagItemTableViewCellDesign.swift
//  Moda
//
//  Created by admin_user on 3/17/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation
 

extension ShoppingBagItemTableViewCell {
 
    func reloadViewsPositions() {

        [UIView]([productImage()!, name, category, brand, currency, countLabel, fullCurrency, size, colorName, selectImage,buttonMinus,buttonMinus]).forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        previewLeadingConstraint = productImage()!.leadingAnchor.constraint(equalTo: leadingAnchor)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                selectImage.leadingAnchor.constraintEqualToSystemSpacingAfter(leadingAnchor, multiplier: 1),
                selectImage.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
//                selectImage.leadingAnchor.constraintEqualToSystemSpacingAfter(leadingAnchor, multiplier: 1),
                selectImage.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        }
    }
    
    
    func animate(revert: Bool) {

        previewLeadingConstraint.isActive = false
        if revert {
            if #available(iOS 11.0, *) {
                previewLeadingConstraint = productImage()!.leadingAnchor.constraintEqualToSystemSpacingAfter(leadingAnchor, multiplier: 6)
            } else {
                // Fallback on earlier versions
                
            }
        } else {
            previewLeadingConstraint = productImage()!.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        previewLeadingConstraint.isActive = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            if revert {
                self.brand.textColor = kColor_LightGray
                self.name.textColor = kColor_LightGray
                self.size.textColor = kColor_LightGray
                self.currency.textColor = kColor_LightGray
                self.colorName.textColor = kColor_LightGray
                self.selectImage.alpha = self.isSelectedToDelete ? 1.0 : 0.5
                
                self.buttonPlus.isHidden = false
                self.buttonMinus.isHidden = false
                self.countLabel.isHidden = false
                self.fullCurrency.isHidden = false
                
            } else {
                self.brand.textColor = kColor_Black
                self.name.textColor = kColor_Black
                self.size.textColor = kColor_Black
                self.currency.textColor = kColor_Black
                self.colorName.textColor = kColor_Black
                self.selectImage.alpha = 0.0
                
                self.buttonPlus.isHidden = true
                self.buttonMinus.isHidden = true
                
                if (self.cellData!.count == nil) || (self.cellData!.count! == 1) {
                    self.countLabel.isHidden = true
                    self.fullCurrency.isHidden = true
                }
              
            }
            self.layoutIfNeeded()
        })
    }
}
