//
//  SliderTableHorizontalCell.swift
//  Moda
//
//  Created by a on 1/6/19.
//  Copyright © 2019 moda. All rights reserved.
//


import ImageSlideshow
import UIKit

class SliderTableHorizontalCell: BaseTableViewCell, UIScrollViewDelegate {
    
    // MARK: - Data
    
    var data: [SliderItem]? { didSet { updateUI() } }
    
    // MARK: - Outlets
    
    @IBOutlet weak var name: UILabel!  
    
    @IBOutlet weak var slider: ImageSlideshow! {
        didSet {
            
            let pgControll = UIPageControl()
            pgControll.currentPageIndicatorTintColor =  kColor_AppBlack
            pgControll.pageIndicatorTintColor = kColor_LightGray
            slider.pageIndicator = pgControll


            slider.slideshowInterval = 5
            slider.clipsToBounds = false
            slider.contentScaleMode = .scaleAspectFill
            slider.activityIndicator = DefaultActivityIndicator()
//            slider.scrollView.delegate = self
         }
    }
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapToSlider))
        slider.addGestureRecognizer(gestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Selectors
    
    @objc func didTapToSlider() {
        
        let productListVC = getVCFromMain("ProductListViewController") as! ProductListViewController
        
        let pageNumber = slider.currentPage
        
        if  pageNumber < data!.count {
            
            productListVC.id = data![pageNumber].category.id
            productListVC.textForTitle = data![pageNumber].category.name.uppercased()
            productListVC.reloadListTags([productListVC.textForTitle])
            
            changeVCInTabBarController(productListVC)
            
        }
        
    } 
    // MARK: - Private methods
    
    private func updateUI() {
        guard data != nil else { return }
        
        var imagesForSlider = [ImageNetSource]()

        data!.forEach {
            imagesForSlider.append(ImageNetSource(url: $0.image.url))
        }
 
        slider.setImageInputs(imagesForSlider)
        name.text = data!.first?.category.name
    }
}

