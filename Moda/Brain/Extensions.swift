//
//  Extensions.swift
//  Moda
//
//  Created by Shin Anatoly on 9/10/19.
//  Copyright © 2019 ason. All rights reserved.
//

import Foundation
extension UIFont {
    public static func gerberaMediumFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gerbera-Medium", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.semibold)
    }
    
    public static func gerberaBoldFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gerbera-Bold", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.bold)
    }
    
    public static func gerberaFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gerbera", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.regular)
    }
    
}

extension String {
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
extension UIImage {
    func changeColor (_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context!.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}
extension UISearchBar {
    func changeSearchBarColor(fieldColor: UIColor, backColor: UIColor, borderColor: UIColor?) {
        UIGraphicsBeginImageContext(bounds.size)
        backColor.setFill()
        UIBezierPath(rect: bounds).fill()
        setBackgroundImage(UIGraphicsGetImageFromCurrentImageContext()!, for: UIBarPosition.any, barMetrics: .default)
        
        let newBounds = bounds.insetBy(dx: 0, dy: 8)
        fieldColor.setFill()
        let path = UIBezierPath(roundedRect: newBounds, cornerRadius: newBounds.height / 2)
        
        if let borderColor = borderColor {
            borderColor.setStroke()
            path.lineWidth = 1 / UIScreen.main.scale
            path.stroke()
        }
        
        path.fill()
        setSearchFieldBackgroundImage(UIGraphicsGetImageFromCurrentImageContext()!, for: UIControlState.normal)
        
        UIGraphicsEndImageContext()
    }
}
extension UIView {
    public func addBottomBorder(_ borderColor: UIColor, borderWidth: CGFloat) {
        addBorder(borderColor, rect: CGRect(x: 15, y: self.frame.height - borderWidth - 3, width: self.frame.width - 30, height: borderWidth))
    }

    public func addBorder(_ borderColor: UIColor, rect: CGRect) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = borderColor.cgColor
        border.frame = rect
        self.layer.addSublayer(border)
    }
    
    public func removeBorder() {
        for border in self.layer.sublayers ?? [CALayer]() {
            if border.name == "borderLayer" {
                border.removeFromSuperlayer()
            }
        }
    }
}

extension UISearchBar {
    
        /// set icon of 20x20 with left padding of 8px
    
    
    func setMagnifyingGlassColorTo(color: UIColor)
    {
        // Search Icon
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.setLeftIcon(#imageLiteral(resourceName: "search.pdf"))
//        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
//        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
//        glassIconView?.tintColor = color
    }
}
extension UITextField {
    func setLeftIcon(_ icon: UIImage) {
        
        let padding = 8
        let size = 17
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
}
