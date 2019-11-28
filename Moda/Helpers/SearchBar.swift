//
//  SearchBar.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/3/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

class JSSearchView: UIView {
    var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        self.searchBar = UISearchBar(frame: self.frame)
        self.searchBar.clipsToBounds = true
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.light
        self.searchBar.layer.cornerRadius = 0
        
        addSubview(self.searchBar)
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(
            item: self.searchBar,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        let trailingConstraint = NSLayoutConstraint(
            item: self.searchBar,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        let yConstraint = NSLayoutConstraint(
            item: self.searchBar,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        
        addConstraints([yConstraint, leadingConstraint, trailingConstraint])
        
        searchBar.backgroundColor = kColor_No
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.tintColor = kColor_Black
        searchBar.layer.borderColor = kColor_AppLightSilver.cgColor
        searchBar.layer.borderWidth = 1

        
        //   searchBar.isTranslucent = true
        //   searchBar.setPlaceholderTextColorTo(color: kColor_Black)
        searchBar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
        self.searchBar.setPositionAdjustment(UIOffset(horizontal: 15, vertical: 0), for: UISearchBarIcon.search)
        for subview in self.searchBar.subviews {
            for view in subview.subviews {
                if let searchField = view as? UITextField {
                    searchField.leftView?.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
                }
            }
        }
        
        for view in self.searchBar!.subviews {
            for possibleTextField in view.subviews {
                if possibleTextField is UITextField {
                    let textField = possibleTextField as! UITextField
                    textField.attributedPlaceholder = NSAttributedString(string: TR("search_placeholder"), attributes: [NSAttributedStringKey.font: UIFont(name: kFont_normal, size: 15)!])
                    textField.layer.cornerRadius = 0
                    textField.layer.borderWidth = 1
                    textField.layer.borderColor = kColor_AppLightGrayTag.cgColor
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for view in self.searchBar!.subviews {
            for possibleTextField in view.subviews {
                if possibleTextField is UITextField {
                    let textField = possibleTextField as! UITextField
                    textField.font = UIFont(name: kFont_normal, size: 15)!
                    var bounds = textField.frame
                    bounds.size.height = 52.5
                    textField.bounds = bounds
                }
            }
        }
    }
}
