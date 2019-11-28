//
//  SliderTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/24/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class SliderTableViewCell: BaseImageTableViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
 
    var sliderItem: SliderItem? {
        didSet {
            self.setUpCellWithData(sliderItem!)
        }
    }
    
    // MARK: - Data
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpCellWithData(_ data : SliderItem) {
        
        self.layoutIfNeeded()
 
        loadImage(data.image.url)
        
        let clearText =  data.text?.html2String ?? kEmpty
        let twoStr = clearText.components(separatedBy: "\n")
        
        let attributedString = NSMutableAttributedString(string: clearText)
 
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: kFont_medium, size: 20)!, NSAttributedStringKey.foregroundColor : kColor_Black ],
                                       range: NSRange(location: 0, length: twoStr[0].count))

        
        if twoStr.count > 1 {
             attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: kFont_llight, size: 16)!],
                        range: NSRange(location: twoStr[0].count + 1, length: twoStr[1].count))
        }
 
        
        titleLabel.attributedText = attributedString
        
    }
  
    
    
}
