//
//  UIView+Extension.swift
//  Moda
//
//  Created by Alimov Islom on 8/8/18.
//  Copyright © 2018 moda. All rights reserved.
//
import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
        func anchors(top:NSLayoutYAxisAnchor? = nil, topPadding:CGFloat = 0, bottom:NSLayoutYAxisAnchor? = nil, bottomPadding:CGFloat = 0, left:NSLayoutXAxisAnchor? = nil, leftPadding:CGFloat = 0 , right:NSLayoutXAxisAnchor? = nil, rightPadding:CGFloat = 0, width:CGFloat = 0, height:CGFloat = 0, centerX:NSLayoutXAxisAnchor? = nil, centerXConst:CGFloat = 0, centerY:NSLayoutYAxisAnchor? = nil, centerYConst:CGFloat = 0){
            translatesAutoresizingMaskIntoConstraints = false
            
            var anchors = [NSLayoutConstraint]()
            
            if let top = top {
                anchors.append(topAnchor.constraint(equalTo: top, constant: topPadding))
            }
            
            if let bottom = bottom {
                anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding))
            }
            if let left = left {
                anchors.append(leftAnchor.constraint(equalTo: left, constant: leftPadding))
            }
            
            if let right = right {
                anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightPadding))
            }
            if let centerX = centerX {
                anchors.append(centerXAnchor.constraint(equalTo: centerX, constant: centerXConst))
            }
            if let centerY = centerY {
                anchors.append(centerYAnchor.constraint(equalTo: centerY, constant: centerYConst))
            }
            
            if width !=  0 {
                anchors.append(widthAnchor.constraint(equalToConstant: width))
            }
            
            if height !=  0 {
                anchors.append(heightAnchor.constraint(equalToConstant: height))
            }
            
            anchors.forEach({$0.isActive = true})
            
        }
}



extension UITableView {
    func reloadTableWithAnimation() {
        if #available(iOS 11.0, *) {
            performBatchUpdates({ reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none) }) { finished in }
        } else {
            // Fallback on earlier versions
            beginUpdates()
            
            reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
            
            endUpdates()
        }
    }
}
