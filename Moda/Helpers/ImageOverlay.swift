//
//  ImageOverlay.swift
//  Moda
//
//  Created by Alyona Din on 11/2/18.
//  Copyright © 2018 moda. All rights reserved.
//


import UIKit

class ImageOverlay: BaseViewController {
 
    @IBOutlet weak var imageView : UIImageView!
    var imagePath           : String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        NetworkManager.shared.getImageInfo(imagePath.encodeUrl()!, errorFunction: showAlertFromNet) { model in
            loadNetImage( URL(string: model.url), self.view, self.imageView)
        }
    
    }

    @IBAction func onExit(){
        
        dismiss(animated: true, completion: nil)
    }
    
}
