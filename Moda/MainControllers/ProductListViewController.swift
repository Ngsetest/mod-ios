//
//  ProductListViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/26/18.
//  Copyright © 2018 moda. All rights reserved.
//


import UIKit

class ProductListViewController: BaseViewControllerWithSorting {

    // MARK: - Data
    
    var data: Collection? {
        didSet {
            reloadTranslations() 
        }
    }
    
    // MARK: - Private properties

    var filterParams = [String : Any]()
    
    var isAllProductBrand: Int! { didSet { productListRequest() } }
    var isThisProductBrand: (Int, Int)! { didSet { productListRequest() } }
    var isAllProductThis: Int! { didSet { productListRequest() } }
    var id: Int? { didSet { productListRequest() } }
    var isBrand = false
    var hiddenTags = [String]()
 
    var currentLargeIndex = 4
    var tempCloseFlag: Bool = false

    var textForTitle = ""
    

    // MARK: - Constraints
    @IBOutlet weak var topBorder: UIImageView!
    @IBOutlet weak var bottomBorder: UIImageView!

    @IBOutlet weak var stackBottomBorderHeight: NSLayoutConstraint!
    @IBOutlet weak var stackTopBorderHeight: NSLayoutConstraint!
    @IBOutlet weak var inputHeight: NSLayoutConstraint!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var tagListHeight: NSLayoutConstraint!

 
    // MARK: - Outlets

    
    var total: UILabel?
    var titleLabel: UILabel?
    
    @IBOutlet weak var stackWithButtons: UIStackView!
    @IBOutlet weak var listTagControl: TLTagsControl!
    @IBOutlet weak var searchBar: UISearchBar!

    
    @IBOutlet weak var filterB: UIButton!
 
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {  collectionView.layoutMargins = UIEdgeInsets.zero  }
    }
    
 
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
  
        if traitCollection.forceTouchCapability == .available { // 3D Touch
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        
        registerCollectionViewCells(collectionView)
 
        setTagControlProperties()
        
        searchBar.changeSearchBarColor(fieldColor: .white, backColor: .white, borderColor: .white)
        searchBar.setMagnifyingGlassColorTo(color: .black)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideLineOfTabBar(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        hideLineOfTabBar(false)
        
        reloadTranslations()
        listTagControl.reloadTagSubviews()
        revealHeader()

        searchBar.removeBorder()
        searchBar.addBottomBorder(.black, borderWidth: 1)
    }
    
    // MARK: - Actions
    
    override func sortingWasChoosen(_ ind  : Int) {
 
        filterParams["sort"] =  sortingVariants[ind]
        productListRequest(isNewFilters: true)

    }
    
    
    @IBAction func onFilters(){
        
        let filterVC = getVCFromMain("FilterViewController") as! FilterViewController
        
        filterVC.tempCloseFlag = tempCloseFlag
        filterVC.filterParams = filterParams
        
        showVC(filterVC)
    }
    
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            inputHeight = searchBar.heightAnchor.constraint(equalToConstant: 0)
            stackHeight = stackWithButtons.heightAnchor.constraint(equalToConstant: 0)
            
            NSLayoutConstraint.activate([
                inputHeight,
                stackHeight
                ])
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.view.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
    
    // MARK: - Private methods

    
    func createNavView(){
        if total == nil {
            let stack = UIStackView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 50)))
            stack.alignment = .fill
            stack.distribution = .fillProportionally
            
            titleLabel = UILabel()
            titleLabel?.text = textForTitle
            titleLabel?.textColor = .black
            titleLabel?.textAlignment = .center
            titleLabel?.font = UIFont(name: kFont_bold, size: 16)
            
            total = UILabel()
            total?.text = " "
            total?.textColor = .gray
            total?.textAlignment = .center
            total?.font = UIFont(name: kFont_bold, size: 12)
            
            stack.addArrangedSubview(titleLabel!)
            stack.addArrangedSubview(total!)
            stack.spacing = 4
            stack.axis = .vertical
            
            navigationItem.titleView = stack
        }

    }
    
    override func reloadTranslations() {
        
        if let totalCount = data?.total {
            total?.text = "\(totalCount) " + TR("total")
        } else {
            total?.text = kEmpty
        }
 
        setSortText(filterParams["sort"] as? String ?? sortingVariants[0])
        filterB.setTitle(TR("filters"), for: .normal)
        collectionView.reloadData()
        
        searchBar.placeholder = "   " + TR("search_placeholder")
        createNavView()

    } 
     
    func setTagControlProperties(){
        
//        editingTagControl.showsVerticalScrollIndicator = false
//        editingTagControl.showsHorizontalScrollIndicator = false
//        let qArr : [String]  =  filterParams["q"] as? [String]  ?? [String]()
//        editingTagControl?.tags =  NSMutableArray(array: qArr)
//        editingTagControl.mode = .edit
//        editingTagControl.tagsTextColor = kColor_White
//        editingTagControl.tagsBackgroundColor = kColor_AppBlack
//        editingTagControl.tagsDeleteButtonColor = kColor_White
//        editingTagControl.font = UIFont(name: kFont_normal, size: 15)!
//        editingTagControl.tintColor = kColor_Black
//        editingTagControl.tapDelegate = self
//        editingTagControl.layer.borderColor = kColor_AppLightSilver.cgColor
//        editingTagControl.layer.borderWidth = 1
//        editingTagControl.layer.cornerRadius = 0
//        editingTagControl.reloadTagSubviews()
        
        
        listTagControl.showsHorizontalScrollIndicator = false
        listTagControl.showsVerticalScrollIndicator = false
        listTagControl.mode = .list
        listTagControl.tapDelegate = self
        listTagControl.font = UIFont(name: kFont_normal, size: 12)!
        listTagControl.tagsTextColor = kColor_White
        listTagControl.tintColor = kColor_White
        
        
        listTagControl.tagsBackgroundColor = kColor_AppBlack
        listTagControl.reloadTagSubviews()
        

        
    }
 
    private func registerCollectionViewCells(_ collectionView: UICollectionView) {
        collectionView.register(
            UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
    }
    

    private func productListRequest(isNewFilters : Bool = false, isNext: Bool = false) {

        if isNext {
            
            sendSearchRequestWith([:], data!.nextPageUrl!.absoluteString, true)

        } else {
            
            if isAllProductBrand != nil {
                filterParams["product"] = ["brand" : isAllProductBrand]
                filterParams["brand"] = [isAllProductBrand]
            } else
            
            if isThisProductBrand != nil {
                filterParams["category"] = [isThisProductBrand.0]
                filterParams["brand"] = [isThisProductBrand.1]
            } else
            
            if isAllProductThis != nil {
                filterParams["product"] = ["category" : isAllProductThis]
                filterParams["category"] = [isAllProductThis]
            } else
                
            if id != 0 {
                let key = (isBrand ? "brand" : "category" )
                filterParams["product"] = [key : id!]
                filterParams[key] = [id!]

            }
 
            sendSearchRequestWith(filterParams)

        }
        
    }
    
    func sendSearchRequestWith(_ filter : [String : Any], _ pathString : String? = nil , _ isNext : Bool = false){
 
        if !isNext{
            addLightLoader()
        }
        
        NetworkManager.shared.getFiltersResults(filter, path : pathString, errorFunction: showAlertFromNet) { model in
          
            self.removeBlurredLoader()
            
            if self.data == nil || !isNext {
                self.data = model
            } else {
                self.data!.data += model.data
                self.data!.nextPageUrl = model.nextPageUrl
            }


        }
    }
    
    func reloadListTags(_ arr : [String]){
        
        listTagControl.tags = []
        
        for tag in arr {
            listTagControl.addTag(tag, propdeleteProperty: "0")
        }
        
        if  let arr2 = filterParams["q"] as? [String] {
            for tag in arr2 {
                listTagControl.addTag(tag, propdeleteProperty: "1")
            }
        }

        
        listTagControl.reloadTagSubviews()
        revealHeader()
    }
}

// MARK: -

extension ProductListViewController: PopViewControllerDelegate {

    func favoriteDidSelect(index: IndexPath){
        
        if let cell = collectionView.cellForItem(at: index) as? ProductCollectionViewCell {
            cell.isFavorite = true
            cell.reloadHeart()
        }

    }
    
    func getDataCell(index : IndexPath) -> Product? {
        
        return data?.data[index.row]
        
    }
}

// MARK: - UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard data != nil else { return 0 }
        return data!.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.identifier,
            for: indexPath
        ) as! ProductCollectionViewCell

        cell.data = data!.data[indexPath.row]
        isItemInFavorites(cell)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
     
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == data!.data.count - 1 && data!.nextPageUrl != nil {
            productListRequest(isNext: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { return 8.0 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { return 8.0 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size: CGSize
        let screenBound = UIScreen.main.bounds
        let screenSize = screenBound.size

        if (indexPath.row + 1) % 5 == 0 {
            // let height = screenSize.height - screenSize.height * 0.65
            size = CGSize(width: screenSize.width - 8.0 * 2, height: screenSize.height * 0.70)
        } else {
            size = CGSize(width: (screenSize.width - 8.0 * 3) / 2, height: 390)
        }
        return size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets { return UIEdgeInsetsMake(5.0, 8.0, 5.0, 8.0) }

    private func random(_ range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension ProductListViewController: UIViewControllerPreviewingDelegate {

    func previewingContext( _ previewingContext: UIViewControllerPreviewing,
                            viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = collectionView.indexPathForItem(at: location),
            let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
            previewingContext.sourceRect = cellAttributes.frame
            return viewControllerForIndexPath(indexPath: indexPath)
            
        }
        return nil
    }

    func previewingContext(  _ previewingContext: UIViewControllerPreviewing,
                             commit viewControllerToCommit: UIViewController)
    {
        show(viewControllerToCommit, sender: self)
        
    }

    private func viewControllerForIndexPath(indexPath: IndexPath) -> UIViewController? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell else { return nil }
        let vc = getVCFromMain("PopViewController") as! PopViewController
        vc.delegate = self
        _ = vc.view
        vc.setProperties(cell.preview.image, indexPath)
        return vc
    }
}

extension ProductListViewController: UIScrollViewDelegate {
    
    func hideHeader(){
        NSLayoutConstraint.deactivate([
            stackTopBorderHeight,
            stackBottomBorderHeight,
            tagListHeight,
            inputHeight,
            stackHeight,
            ])
        stackTopBorderHeight = topBorder.heightAnchor.constraint(equalToConstant: 0)
        stackBottomBorderHeight = bottomBorder.heightAnchor.constraint(equalToConstant: 0)
        tagListHeight = listTagControl.heightAnchor.constraint(equalToConstant: 0)
        inputHeight = searchBar.heightAnchor.constraint(equalToConstant: 0)
        stackHeight = stackWithButtons.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            stackBottomBorderHeight,
            stackTopBorderHeight,
            tagListHeight,
            inputHeight,
            stackHeight
            ])
        
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.sort.alpha = 0.0
                self.stackWithButtons.arrangedSubviews.forEach { $0.layer.opacity = 0 }
                self.view.layoutIfNeeded()
        },
            completion: nil
        )

    }
    
    func revealHeader(){
        
        NSLayoutConstraint.deactivate([
            stackTopBorderHeight,
            stackBottomBorderHeight,
            tagListHeight,
            inputHeight,
            stackHeight
            ])
        stackBottomBorderHeight = bottomBorder.heightAnchor.constraint(equalToConstant: 1.0)
        stackTopBorderHeight = topBorder.heightAnchor.constraint(equalToConstant: 1.0)
        tagListHeight = listTagControl.heightAnchor.constraint(equalToConstant: 36.0)
        inputHeight = searchBar.heightAnchor.constraint(equalToConstant: 45.0)
        stackHeight = stackWithButtons.heightAnchor.constraint(equalToConstant: 24.0)
        
        NSLayoutConstraint.activate([
            stackTopBorderHeight,
            stackBottomBorderHeight,
            tagListHeight,
            inputHeight,
            stackHeight
            ])
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.sort.alpha = 1.0
                self.stackWithButtons.arrangedSubviews.forEach { $0.layer.opacity = 1 }
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeader()
        } else if scrollView.panGestureRecognizer.translation(in: scrollView).y > 50 {
            revealHeader()
            
        }
    }
}

// MARK: - TLTagsControlDelegate

extension ProductListViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let tag = searchBar.text{
            listTagControl.addTag(tag, propdeleteProperty: "1")
            hiddenTags.append(tag)
            searchBar.text = nil

       
            searchBar.resignFirstResponder()
            onSearch()
            
        }
    }
    
    func onSearch(){

        filterParams["q"] = hiddenTags
        
        productListRequest(isNewFilters: true)

    }
    
}


extension ProductListViewController: TLTagsControlDelegate {
    
    
    func tagsControl(_ tagsControl: TLTagsControl!, tappedAt index: Int) {
 
    }

    
    func tagsControl(_ tagsControl: TLTagsControl!, removedAt index: Int) {

        onSearch()

    }
    

}
