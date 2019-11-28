//
//  SelectLanguageVC.swift
//  Moda
//
//  Created by admin_user on 9/9/19.
//  Copyright © 2019 mod. All rights reserved.
//

import Foundation
import UIKit


class SelectLanguageVC : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stack: UIStackView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = TR("choose_lang").capitalized
        
    }
    
    @IBAction func onLang(_ button : UIButton){
        var keys : [String] = ["ru","uz"]
          
        saveLang(keys[button.tag])
        let vc = getVCFromMain("NotificationViewController")
        UIApplication.shared.keyWindow?.rootViewController = vc
            
    
    }
}
