//
//  CatalogueCollectionCell.swift
//  Moda
//
//  Created by admin_user on 3/30/19.
//  Copyright © 2019 moda. All rights reserved.
//


 import UIKit

class CatalogueCollectionCell: BaseImageCollectionViewCell {
   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!

    var data: SliderItem? { didSet { self.updateUI() } }
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    } 
    
    // MARK: - Private methods
    
    private func updateUI() {
        layoutIfNeeded()

        guard self.data != nil else { return }
        
        loadImage(data!.image.url)
        name.text = data!.category.name
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 4
        
    }
}
