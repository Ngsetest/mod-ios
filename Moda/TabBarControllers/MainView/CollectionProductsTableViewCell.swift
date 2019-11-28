//
//  CollectionProductsTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/24/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class CollectionProductsTableViewCell: BaseTableViewCell {
   
  // MARK: - Data
   var data: Collection? { didSet { collectionView.reloadData() } }
    
  // MARK: - Outlets
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var title: UILabel!
    @IBOutlet weak var see_all: UIButton!{
        didSet{
            self.see_all.setTitle(TR("see_all"), for: .normal)
        }
    }

  // MARK: - Properties 
  
  var isInProductCard = false
  
  // MARK: - Lifecycle methods
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
 
    registerCollectionViewCells(collectionView)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
    
    @IBAction func onSeeAll(){
 
        let productListVC = getVCFromMain("ProductListViewController") as! ProductListViewController
        
        productListVC.id = data?.data.first?.category.id ?? 0
        productListVC.textForTitle = data?.data.first!.category.name.uppercased() ?? kEmpty
        productListVC.reloadListTags([productListVC.textForTitle])
        
        changeVCInTabBarController(productListVC)
        
    }
    
  // MARK: - Private methods
  
  private func registerCollectionViewCells(_ collectionView: UICollectionView) {
    collectionView.register(
      UINib(nibName: ProductCollectionViewCellMain.identifier, bundle: nil),
      forCellWithReuseIdentifier: ProductCollectionViewCellMain.identifier
    )
  }
}

// MARK: - UICollectionViewDataSource

extension CollectionProductsTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProductCollectionViewCellMain.identifier,
      for: indexPath) as! ProductCollectionViewCellMain
 
    cell.data = data!.data[indexPath.row]
    
    if !isInProductCard {
        isItemInFavorites(cell)
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionProductsTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 155, height: 320)
  }
}
