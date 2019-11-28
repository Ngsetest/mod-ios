//
//  PopViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/7/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

protocol PopViewControllerDelegate {
    
    func favoriteDidSelect(index: IndexPath)
    func getDataCell(index : IndexPath) -> Product?

}

class PopViewController: BaseViewController {
    
    var data: Product?
    var index : IndexPath!
    
    var delegate : PopViewControllerDelegate?
 
    @IBOutlet weak var popImage: UIImageView!
    
    func setProperties(_ image : UIImage?, _ indexNew : IndexPath){
        
        guard let product = delegate?.getDataCell(index: indexNew) else { return}
 
        navigationItem.title = product.name
        popImage.image = image
        index = indexNew
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        
        guard let product = delegate?.getDataCell(index: index) else { return [] }
        
        return [
            
//            UIPreviewAction(title: TR("add_to_cart"), style: .default, handler: { action , vc in
//                
//                editBagList(products: [product], true, answerFunction:  {newArray in
//                    
//                })
//                
//            }),
            
            UIPreviewAction(title: TR("add_to_favorites"), style: .default, handler: { action, vc in
                
                editFavoriteList(products: [product], addAction: true, answerFunction:  {newArray in
                    
                    self.delegate?.favoriteDidSelect(index: self.index)
                    
                })

            }),
            
            UIPreviewAction(title: TR("cancel"), style: .destructive, handler: { action, vc in
                self.dismiss(animated: true, completion: nil)
            }),
        ]
    }
}
