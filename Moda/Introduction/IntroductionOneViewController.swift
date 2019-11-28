//
//  IntroductionOneViewController.swift
//  Moda
//
//  Created by admin_user on 3/18/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation

class IntroductionOneViewController: BaseViewController {
    
    @IBOutlet weak var middleText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
    }
    
    
    override func reloadTranslations() {
        
        let tag = "\(view.tag + 1)"
        
        middleText.text = TR("tutorial_text_" + tag)
        imageView.image = UIImage(named: "tutorial_image_" + tag)
        
    }
    
}
