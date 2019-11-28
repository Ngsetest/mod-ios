//
//  CollectionCatalogueTableViewCell.swift
//  Moda
//
//  Created by admin_user on 3/30/19.
//  Copyright © 2019 moda. All rights reserved.
//

import UIKit

class CollectionCatalogueTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var labelTitle: UILabel!
 
    var data: [SliderItem]? { didSet { self.updateUI()  } }
 
    // MARK: - Lifecycle methods
    
    func updateUI(){

        registerCollectionViewCells(collectionView)
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func registerCollectionViewCells(_ collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: CatalogueCollectionCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: CatalogueCollectionCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionCatalogueTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogueCollectionCell.identifier,
                                                      for: indexPath) as! CatalogueCollectionCell
        
        cell.data = data?[indexPath.row] 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let dataItem = data?[indexPath.row] {
            
            let productListVC = getVCFromMain("ProductListViewController") as! ProductListViewController

            productListVC.id = dataItem.category.id
            productListVC.textForTitle = dataItem.category.name.uppercased()
            productListVC.reloadListTags([productListVC.textForTitle])
            
            changeVCInTabBarController(productListVC)
            
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionCatalogueTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }
}
