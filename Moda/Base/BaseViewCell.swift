//
//  BaseTableViewCell.swift
//  Moda
//
//  Created by admin_user on 3/24/19.
//  Copyright © 2019 moda. All rights reserved.
//


import UIKit


class BaseTableViewCell : UITableViewCell {

    // MARK: - Lifecycle methods 
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func getLabel(_ tag : Int) -> UILabel? {
        
        return (contentView.viewWithTag(tag) as? UILabel)
    }
    
    func getButton(_ tag : Int) -> UIButton? {
        
        return (contentView.viewWithTag(tag) as? UIButton)
    }
    
    func getImageView(_ tag : Int) -> UIImageView? {
        
        return (contentView.viewWithTag(tag) as? UIImageView)
    }
    
}

class BaseImageTableViewCell : BaseTableViewCell {
    
    func productImage() -> UIImageView? {
        
        return  getImageView(10)
    }
    
    func loadImage(_ imgUrlNew : URL?){
        
        loadNetImage(imgUrlNew, contentView, productImage())
        
    }
    
}


class BaseCollectionViewCell : UICollectionViewCell {
    
    // MARK: - Lifecycle methods
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func getImageView(_ tag : Int) -> UIImageView? {
        
        return (contentView.viewWithTag(tag) as? UIImageView)
    }
}

class BaseImageCollectionViewCell : BaseCollectionViewCell {
    
    func productImage() -> UIImageView? {
        
        return  getImageView(10)
    }
    
    func loadImage(_ imgUrlNew : URL?){
        
        loadNetImage(imgUrlNew, contentView, productImage())
        
    }
    
}
