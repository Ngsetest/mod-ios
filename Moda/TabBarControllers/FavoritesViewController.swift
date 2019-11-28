//
//  FavoritesViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/29/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit


class FavoritesViewController: BaseViewControllerWithSorting {

    // MARK: - Data

    var data: [Product]? {
        didSet {
            collectionView.performBatchUpdates({ collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet) }) {
                (finished: Bool) -> Void in
                self.reloadEmptyView()
            }
        }
    }
 
    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    private var isFirstAppeared = true

    
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyLabel2: UILabel!
    @IBOutlet weak var emptyButton: UIButton!
    
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCollectionViewCells(collectionView)

        addBlurredLoader(with: getBlurredHeight())
        
        getFavorite()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        emptyView.isHidden = true
 
        if !isFirstAppeared {
            addBlurredLoader(with: getBlurredHeight())
            getFavorite()
        }
        
        isFirstAppeared = false
        reloadTranslations()
    }
 
    
    override func reloadTranslations() {
 
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationItem.title = TR("favorites")
        emptyLabel.text = TR("favorites_empt_1")
        emptyLabel2.text = TR("favorites_empty_2")
        emptyButton.setTitle(TR("start_buy"), for: .normal)
        emptyButton.layer.borderColor = kColor_LightGray.cgColor
        
    }
    // MARK: - Private methods

    private func registerCollectionViewCells(_ collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
    }

    private func getFavorite() {
        
        editFavoriteList(errorFunction: { (_ error: String) in
            
            self.showAlert(error)
            
            self.removeBlurredLoader()

            
        }) { (favList : [Product]) in
            
            self.data = favList

            self.removeBlurredLoader() 
        }
    
    }
    
    func reloadEmptyView(){
        
        emptyView.isHidden = !(data?.isEmpty ?? true)

    }
    
    // MARK: - IBAction
    
    @IBAction func onStartBuy(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 0
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard data != nil else { return 0 }
        return data!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.identifier,
            for: indexPath ) as! ProductCollectionViewCell
        cell.isFavorite = true
        cell.isHeart = true
        cell.data = data![indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screenBound = UIScreen.main.bounds
        let screenSize = screenBound.size
        return CGSize(width: (screenSize.width - 8.0 * 3) / 2, height: 390)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 8, 0, 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
