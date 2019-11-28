//
//  PriceRangeTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/20/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import RangeSeekSlider
import UIKit

class PriceRangeTableViewCell: BaseFilterViewControllerCell {
  
    @IBOutlet weak var sliderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: RangeSeekSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSliderProperties() 
    }
    
    
    //MARK: - Override
    
    
    override func setNamesProperties(){
        
        tableeOffset = 0
        contentOffset = 109.5
        
        nameOfCellSector = kEmpty
        nameOfCellSector = "price"
        nameTitleKey = "prices"

    } 
    
    //MARK: -
    
    override func setContentViewHeightConstraint(_ offsetY: CGFloat) {
        
        sliderHeightConstraint.isActive = false
        let heightOfView = (superview?.bounds.height  ?? 0 )  - offsetY
        sliderHeightConstraint = slider.heightAnchor.constraint(equalToConstant: heightOfView)
        sliderHeightConstraint.isActive = true
        slider.isHidden = heightOfView == 0 
    }
  
    
    override func updateSubTitleOfFilter() {
        
        let min =  Int(slider.selectedMinValue)
        let max =  Int(slider.selectedMaxValue)
        
        ids = [min, max]
        title.text = setNiceCurrancy(min)  + " - " + setNiceCurrancy(max)

    }
    
    override func getTitlesForTags() -> [String] {
        
        return [(title.text ?? kEmpty) ]
        
    }
    
    override func reloadTranslations() {
        
        
        if ids.count == 2 {
            setSliderValues(ids[0], ids[1])
        }
        
        super.reloadTranslations()
 
    }
}

extension PriceRangeTableViewCell: RangeSeekSliderDelegate {
     
    
    func setMaxMinValues(_ min : CGFloat, _ max : CGFloat){
        
        slider.minValue = min
        slider.maxValue = max
        slider.selectedMinValue = min
        slider.selectedMaxValue = max
     }
    
    
    func setSliderValues(_ min : Int, _ max : Int){
        
        slider.selectedMinValue = CGFloat(min)
        slider.selectedMaxValue = CGFloat(max)
        
        updateSubTitleOfFilter()
        
    }
    
    func setSliderProperties(){
        
        slider.delegate = self
        slider.minLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        slider.maxLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        setContentViewHeightConstraint(0)
    }
    
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat){
       
       updateSubTitleOfFilter()
    }
}
