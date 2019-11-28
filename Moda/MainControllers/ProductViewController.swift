//
//  ProductViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/25/18.
//  Copyright © 2018 moda. All rights reserved.
//

import ImageSlideshow
import TTSegmentedControl
import UIKit

class ProductViewController: BaseViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backButton: UIButton!
    private var backSelected = false
    private var beginPoint: CGPoint = .zero
    
    // MARK: - Outlets
    
    @IBOutlet weak var slider: ImageSlideshow! {
        didSet {
            let pgControll = UIPageControl()
            pgControll.currentPageIndicatorTintColor =  kColor_AppBlack
            pgControll.pageIndicatorTintColor = kColor_LightGray
            pgControll.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

            slider.pageIndicator = pgControll
            //            slider.slideshowInterval = 3
            slider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 8), vertical: .bottom)
            slider.contentScaleMode = UIViewContentMode.scaleAspectFill
            slider.activityIndicator = DefaultActivityIndicator()
        }
    }
    @IBOutlet weak  private var slider_HeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak  var colorName: UILabel!
    @IBOutlet weak  var colorCollection: UICollectionView!
    
    
    @IBOutlet weak  var brand: UILabel!
    @IBOutlet weak  var name: UILabel!
    @IBOutlet weak  var category: UILabel!
    @IBOutlet weak  var price: UILabel!
    @IBOutlet weak  var oldPrice: UILabel!
    
    @IBOutlet weak  var sizeName: UILabel!
    @IBOutlet weak var findMySize: UIButton!
    
    @IBOutlet weak  var sizeCollection: UICollectionView!
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var addToFavorite: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var showProductInfoButton: UIButton!
    @IBOutlet weak var consistenceAndCare: UIButton!
    
    //    @IBOutlet weak var moreQuestions: UIButton!
    @IBOutlet weak var deliveryAndFitting: UIButton!
    
    
    
    @IBOutlet weak  var allProductsThisBrand: UIButton!
    @IBOutlet weak  var allProductsThisCategoryAndBrand: UIButton!
    @IBOutlet weak  var allProductsThisCategory: UIButton!
    
    
    @IBOutlet weak  var deliveryBigTitle: UILabel!
    
    @IBOutlet weak  var deliveryLabel: UILabel!
    @IBOutlet weak  var deliveryLabelDate: UILabel!
    
    @IBOutlet weak  var returnLabel: UILabel!
    @IBOutlet weak  var returnLabelInfo: UILabel!
    
    @IBOutlet weak  var similarCollection: UICollectionView!
    
    @IBOutlet weak var lorem: UIMarginLabel!
    @IBOutlet weak var lorem2: UIMarginLabel!
    
    @IBOutlet weak  var headerTitle1: UILabel!
    @IBOutlet weak  var headerTitle2: UILabel!
    @IBOutlet weak  private var headerTitle2_HeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak  var lastSeenCollection: UICollectionView!
    @IBOutlet weak  private var lastSeenCollection_HeightConstraint: NSLayoutConstraint!
    
    
    private var lastSeen: [Product]? {
        didSet {
            lastSeen?.reverse()
        }
    }
    
    private var isInFavorite = false
    private var data: FullProductModel? {
        didSet {
            if oldValue == nil {
                
                updateUI()
            }
        }
    }
    
    //MARK: - Functions
    
    func removeSelfIdFromSeen(){
        
        let idOfProductroduct =  data?.id ?? -1
        
        lastSeen = lastSeen?.filter{ $0.id != idOfProductroduct }
        
    }

    @IBOutlet weak var scrollView: UIScrollView!
    private func fitUICollectionViewsHeight(){
        
        removeSelfIdFromSeen()
        
        let isEmpty = (self.lastSeen == nil) || (self.lastSeen!.count < 1)
        
        headerTitle2_HeightConstraint.constant = isEmpty ? 0 : 34
        lastSeenCollection_HeightConstraint.constant = isEmpty ? 0 : 360
        headerTitle2.isHidden = isEmpty
    }
    
    var productShortData: ShortProduct!
    
    
    // MARK: - View Controller
    
    deinit {
        lastSeen = nil
        slider = nil
        data = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private var topSafeArea: CGFloat!
    private var bottomSafeArea: CGFloat!
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        
        super.viewDidLoad()
        
        setInfoViewProperties()
        
        productRequest(productShortData.id)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(sender:)))
        self.view.addGestureRecognizer(pan)
        
        scrollView.delegate = self
    }
    
    private func updateUI() {
        
        guard data != nil else { return }
        
        data!.count = productShortData.count
        
        let colorId = productShortData.color?.id ?? data?.variations.first?.colorId
        data!.color = data?.colors.filter{ $0.id == colorId }.first ?? data?.colors.first
        
        
        if data?.sizes.count == 1 {
            data!._size = data?.sizes.first
        } else {
            let sizeId = productShortData.size?.id ?? data?.variations.first?.sizeId
            data!._size = data?.sizes.filter{ $0.id == sizeId }.first
        }
        
        findMySize.isHidden = data!.category.sizetablemarkup == nil
        
        setTitles()
        
        setSliderProperties()
        
        setSliderImages()
        
        setPricesLabels()
        
        saveInLastViews()
        
        getFavoriteStatus()
        
        show(showProductInfoButton)
        
        colorCollection.reloadData()
        sizeCollection.reloadData()
        
        updateCollectionViews()
        
        similarCollection.reloadData()
        lastSeenCollection.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationItemProperties()
        
        reloadTranslations()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViews()
        
    }
    // MARK: - Actions
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        
        guard data != nil else { return }
        
        editFavoriteList(products: [data!.getProduct()], addAction: !isInFavorite, errorFunction: { error  in
            
            debugLog(error)
            
        }) { newArray in
            
            self.isInFavorite = !self.isInFavorite
            self.reloadHeart()
            
        }
        
    }
    
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            beginPoint = sender.location(in: sender.view)
        case .ended:
            if beginPoint.x > 50 {
                return
            }
            let now = sender.location(in: sender.view)
            if abs(beginPoint.x - now.x) >= view.frame.width/3  {
                if backSelected {
                    return
                }
                backSelected = true
                self.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
    
    
    @IBAction func addToBag(_ sender: UIButton) {
        
        if data?.color == nil {
            data?.color = data?.colors.first
        }
        
        if (data?._size == nil) && (data?.sizes.count == 1){
            data?._size = data?.sizes.first
        }
        
        
        guard self.data!._size != nil else {
            showAlert(TR("choose_size"))
            return
        }
        
        editBagList(products: [data!.getProduct()], addAction: true, errorFunction: { error in
            
            debugLog("addToBag " + error)
            
        }) { list in
            
            
        }
    }
    
    @IBAction func show(_ sender: UIButton) {
        switch sender  {
        case showProductInfoButton :
            let image = lorem.isHidden ? UIImage(named: "minus") : UIImage(named: "add-plus-button")
            sender.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.bounds.width - 55, bottom: 0, right: 0)
            UIView.transition(
                with: sender,
                duration: 0.3,
                options: .transitionFlipFromTop,
                animations: { sender.setImage(image, for: .normal) },
                completion: nil
            )
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [.transitionCrossDissolve],
                animations: {
                    self.lorem.isHidden = !self.lorem.isHidden
            }
            ) { position in
                // ...
            }
        case consistenceAndCare :
            let image = lorem2.isHidden ? UIImage(named: "minus") : UIImage(named: "add-plus-button")
            sender.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.bounds.width - 55, bottom: 0, right: 0)
            UIView.transition(
                with: sender,
                duration: 0.3,
                options: .transitionFlipFromTop,
                animations: { sender.setImage(image, for: .normal) },
                completion: nil
            )
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [.transitionCrossDissolve],
                animations: {
                    self.lorem2.isHidden = !self.lorem2.isHidden
            }
            ) { position in
                // ...
            }
            break
        default:
            break
        }
    }
    
    @IBAction func onShare(_ sender: UIButton) {
        
        if let url = URL(string:  data?.url ?? data?.sharelink ?? kAppLinkWeb) {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    @IBAction func goToAllProducts(_ sender: UIButton) {
        
        let nextVC = getVCFromMain("ProductListViewController") as! ProductListViewController
        
        switch sender{
        case allProductsThisBrand :
            nextVC.isAllProductBrand = self.data!.brand.id
            nextVC.textForTitle = self.data!.brand.name.uppercased()
            nextVC.reloadListTags([nextVC.textForTitle])
            nextVC.tempCloseFlag = true
            
        case allProductsThisCategoryAndBrand :
            nextVC.isThisProductBrand = (self.data!.category.id, self.data!.brand.id)
            nextVC.textForTitle = self.data!.category.name.uppercased()
            nextVC.reloadListTags([nextVC.textForTitle, data!.brand.name.uppercased()])
            
        case allProductsThisCategory:
            nextVC.isAllProductThis = self.data!.category.id
            nextVC.textForTitle = self.data!.category.name.uppercased()
            nextVC.reloadListTags([nextVC.textForTitle])
            
        default:
            break
        }
        
        showVC(nextVC)
        
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func goFindMySize(_ sender: UIButton) {
        
        let path = data!.category.sizetablemarkup
        
        showVCFromName("WebViewOverlay", funcPreInit: { vc in
            let webvc = vc as! WebViewOverlay
            webvc.pathHTML = path
            webvc.heightShift = 80.0
        }, isOverLayer: true)
        
    }
    
    
    @IBAction func onMoreQuestions(_ sender: UIButton) {
        
        
    }
    
    @IBAction func onDeliveryAndFittings(_ sender: UIButton) {
        
        
    }
    
    // MARK: - Selectors
    
    @objc func didTapToSlider() {
        let fullScreenController = slider.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    // MARK: - Private methods
    
    func updateCollectionViews(){
        
        guard data != nil else { return }
        
        var shift_Size = view.frame.width - CGFloat(data!.colors.count) * view.frame.size.width / 5
        shift_Size =  min(0, -shift_Size/2)
        colorCollection.setContentOffset(CGPoint(x:shift_Size, y: 0), animated: true)
        if shift_Size < 0 {
            colorCollection.isScrollEnabled = false
        }
        
        shift_Size = view.frame.width - CGFloat(data!.sizes.count) * view.frame.size.width / 5
        shift_Size =  min(0, -shift_Size/2)
        sizeCollection.setContentOffset(CGPoint(x:shift_Size, y: 0), animated: true)
        if shift_Size < 0 {
            sizeCollection.isScrollEnabled = false
        }
        
        if (data?.colors.count ?? 0) <= 1 {
            colorCollection.isHidden = true
            colorName.isHidden = true
        }
    }
    
    func getFavoriteStatus(){
        
        let product = data!.getProduct()
        editFavoriteList { favorites in
            
            self.isInFavorite  =  favorites.contains(where: { item -> Bool in
                item.isEqualToProduct(product, false)
            })
            
            self.reloadHeart()
        }
    }
    
    func reloadHeart(){
        
        addToFavorite.setImage(UIImage(named: isInFavorite ? "heart2": "heart"), for: .normal)
        
    }
    
    
    func setNavigationItemProperties(){
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        hideLineOfTabBar(true)
        
        clearBackButton()
        
        //        title =  productShortData.brand.name.uppercased()
        
    }
    
    
    
    func setInfoViewProperties(){
        
        showProductInfoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.bounds.width - 55, bottom: 0, right: 0)
        consistenceAndCare.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.bounds.width - 55, bottom: 0, right: 0)
        
        
        colorCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell_color")
        sizeCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell_size")
        
        similarCollection.register( UINib(nibName: ProductCollectionViewCellMain.identifier, bundle: nil),
                                    forCellWithReuseIdentifier: "cell_similar")
        
        lastSeenCollection.register( UINib(nibName: ProductCollectionViewCellMain.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: "cell_lastSeen")
        
    }
    
    
    override func reloadTranslations() {
        
        findMySize.setTitle(TR("find_my_size"), for: .normal)
        
        addToCart.setTitle(TR("add_to_cart"), for: .normal)
        addToCart.layer.borderColor = UIColor.white.cgColor
        addToCart.layer.borderWidth = 6
        addToCart.layer.cornerRadius = 4
        addToCart.clipsToBounds = true
        
        addToFavorite.setTitle(TR("to_favorites"), for: .normal)
        addToFavorite.imageView?.contentMode = .scaleAspectFit
        addToFavorite.imageEdgeInsets = UIEdgeInsets(
            top: 15,
            left: 15,
            bottom: 15,
            right: 15)

        showProductInfoButton.setTitle(TR("info_about_good").uppercased(), for: .normal)
        consistenceAndCare.setTitle(TR("info_composition_care"), for: .normal)
        shareButton.setTitle(TR("share"), for: .normal)
        
        //        moreQuestions.setTitle(TR("more_questions").uppercased(), for: .normal)
        deliveryAndFitting.setTitle(TR("delivery_fitting").uppercased(), for: .normal)
        deliveryAndFitting.addTarget(self, action: #selector(deliveryAndFittingAction), for: .touchUpInside)
        
        deliveryBigTitle.text = TR("delivery_big_title")        
        deliveryLabel.text = TR("delivery")
        returnLabel.text = TR("refund")
        returnLabelInfo.text = TR("refund_info")
        
        //haveMoreQuestions.text = TR("have_questions_")
        
        
        headerTitle1.text = TR("similar_goods")
        headerTitle2.text = TR("your_history_view")
        
    }
    
    
    private func setTitles() {
        
        
        brand.text      = data?.brand.name.uppercased()
        name.text       = data?.name
        category.text   = data?.category.name
        
        lorem.text      = data!.description ?? data!.name
        lorem2.text     = data!.composition
        
        
        getDeliveryModel{
            self.deliveryLabelDate.text = chooseDeliveryDateLine(.AFTER_TOMORROW, withDescription: false)
        }
        
        
        allProductsThisBrand.setTitle(
            TR("all") + " \(data!.brand.name)",
            for: .normal
        )
        allProductsThisCategoryAndBrand.setTitle(
            TR("all") + " \(data!.category.name) \(data!.brand.name)",
            for: .normal
        )
        allProductsThisCategory.setTitle( TR("others") + " \(data!.category.name)",
            for: .normal)
        
        colorName.text =   data!.color?.name
        
    }
    
    
    
    private func saveInLastViews() {
        
        editViewList(products:  [ data!.getProduct()], true ) { newList in
            
            self.lastSeen = newList
            self.fitUICollectionViewsHeight()
            self.lastSeenCollection.reloadData()
            
        }
        
    }
    
    func setSliderProperties(){
        
        slider_HeightConstraint.isActive = false
        slider_HeightConstraint = slider.heightAnchor.constraint(equalToConstant:
            UIScreen.main.bounds.height * 0.65)
        slider_HeightConstraint.isActive = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapToSlider))
        slider.addGestureRecognizer(gestureRecognizer)
    }
    
    
}

// MARK: - NetWorking

extension ProductViewController {
    
    private func productRequest(_ id: Int) {
        
        addBlurredLoader(with: getBlurredHeightForFull())
        
        NetworkManager.shared.getProductInfo(id, errorFunction: { code, error in
            
            self.removeBlurredLoader()
            
            self.showAlert(code == 404 ? TR("no_goods_left") : error, handlerOnOK: {
                self.navigationController?.popViewController(animated: true)
            })
            
            
        }) { model in
            
            self.moveDataFromShortDescriptions(model)
            self.removeBlurredLoader()
        }
    }
    
    
    func moveDataFromShortDescriptions(_ model : FullProductModel){
        
        data = model
        
    }
    
    
    func setPricesLabels(){
        setNicePrices(data!.getChoosenVariation(), &price, &oldPrice)
    }
    
    // MARK: - Settings
    
    private func setSliderImages(){
        
        guard let colorID = data?.color?.id, let dataGallery = data?.gallery  else  {  return  }
        
        var imagesForSlider = [ImageNetSource]()
        dataGallery.filter { $0.colorId == colorID }
            .forEach { imagesForSlider.append(ImageNetSource(url: $0.url)) }
        
        self.slider.setImageInputs(imagesForSlider)
        
    }
    
    private func getWidth() -> CGFloat {
        guard self.data != nil else { return 0 }
        
        var count = 0
        var text = kEmpty
        data!.sizes.forEach {
            if $0.name.count > count {
                count = $0.name.count
                text = $0.name
            }
        }
        let string = NSString(string: text)
        return string.size(withAttributes: [.font: UIFont(name: kFont_normal, size: 15)!]).width
    }
    
    
    // MARK: - UICollection
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let i = indexPath.row
        switch collectionView {
        case colorCollection:
            data?.color = data!.colors[i]
            colorName.text = data!.color?.name
            colorCollection.reloadData()
            break
        case sizeCollection:
            data?._size = data!.sizes[i]
            sizeCollection.reloadData()
            break
        default:
            break
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case colorCollection: return data?.colors.count ?? 0
        case sizeCollection: return data?.sizes.count ?? 0
        case similarCollection: return data?.relationProducts.data.count ?? 0
        case lastSeenCollection: return lastSeen?.count ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case  colorCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_color", for: indexPath)
            cell.layoutIfNeeded()
            
            var face : UIImageView!
            if let item = cell.contentView.viewWithTag(1) as? UIImageView{
                face = item
            } else {
                face =  UIImageView(frame : CGRect(origin: .zero, size: cell.contentView.frame.size))
                face.tag = 1
                face.layer.borderWidth = 0.5
                cell.contentView.addSubview(face)
            }
            
            if data!.color == data!.colors[indexPath.row]{
                face.layer.borderColor = UIColor.black.cgColor
                face.layer.borderWidth = 1
            } else {
                face.layer.borderColor = UIColor.clear.cgColor
                face.layer.borderWidth = 0.1
            }
            
            let colorId = data?.colors[indexPath.row].id
            let colorImageUrl = data?.variationImages.filter{ $0.colorId == colorId }.first?.url
            
            if colorImageUrl == nil {
                face.backgroundColor = data?.colors[indexPath.row].value.hexColor ?? kColor_White
                return cell
            }
            
            ImageNetSource(url: colorImageUrl!).load(to: face) { image in
                face.image = image
            }
            
            return cell
            
        case sizeCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_size", for: indexPath)
            cell.layoutIfNeeded()
            
            var face : UILabel!
            if let item = cell.contentView.viewWithTag(1) as? UILabel{
                face = item
            } else {
                face =  UILabel(frame : CGRect(origin: .zero, size: cell.contentView.frame.size))
                face.textAlignment = .center
                face.numberOfLines = 0
                face.font = UIFont(name: kFont_bold, size: 12)
                face.adjustsFontSizeToFitWidth = true
                face.tag = 1
                //face.layer.borderColor = UIColor.darkGray.cgColor
                //face.layer.borderWidth = 0.5
                cell.contentView.addSubview(face)
            }
            
            if data!._size == data!.sizes[indexPath.row]{
                face.textColor = .white
                face.backgroundColor = .black
            } else {
                face.textColor = .darkGray
                face.backgroundColor = .white
            }
            
            face.text = data?.sizes[indexPath.row].name.replacingOccurrences(of: " ", with: "\n")
            
            return cell
            
        case similarCollection:
            let cell = collectionView.dequeueReusableCell(  withReuseIdentifier: "cell_similar", for: indexPath) as! ProductCollectionViewCellMain
            cell.layoutIfNeeded()
            
            cell.data = data!.relationProducts.data[indexPath.row]
            isItemInFavorites(cell)
            
            return cell
            
        case lastSeenCollection:
            
            let cell = collectionView.dequeueReusableCell(  withReuseIdentifier: "cell_lastSeen", for: indexPath) as! ProductCollectionViewCellMain
            cell.layoutIfNeeded()
            
            cell.data = Collection(fromArray: lastSeen!).data[indexPath.row]
            isItemInFavorites(cell)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case colorCollection: return CGSize(width: self.view.frame.width / 5, height: 90)
        case sizeCollection: return CGSize(width: 40, height: 40)
        case similarCollection: return CGSize(width: self.view.frame.width / 2, height: 360)
        case lastSeenCollection: return CGSize(width: self.view.frame.width / 2, height: 360)
        default: return .zero
        }
    }
    
    
    @objc private func deliveryAndFittingAction() {
        if let url = URL(string: "https://mod.uz/pages/dostavka") {
            UIApplication.shared.open(url)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            print(scrollView.contentOffset.y)
            let full = topSafeArea
            let percent = abs(scrollView.contentOffset.y/(full ?? 1))
            
            if scrollView.contentOffset.y > 0 {
                return
            } else {
                self.backButton.setImage(#imageLiteral(resourceName: "back.png").changeColor(UIColor.black.withAlphaComponent(CGFloat(percent))), for: .normal)
            }
        }
    }
}


// MARK: - extension

extension Collection {
    
    init(fromArray: [Product]) {
        self.init(
            currentPage: fromArray.count,
            data: fromArray,
            perPage: fromArray.count,
            firstPageUrl: URL(string: kSiteForShare)!,
            nextPageUrl: nil,
            prevPageUrl: nil,
            total: fromArray.count
        )
    }
    
}


class UIMarginLabel: UILabel {
    
    var topInset: CGFloat = 0
    var rightInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(
            top: self.topInset,
            left: self.leftInset,
            bottom: self.bottomInset,
            right: self.rightInset
        )
        self.setNeedsLayout()
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}


extension UIButton {
    
    func underline(_ text : String) {
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedStringKey.underlineStyle,
            value: NSUnderlineStyle.styleThick.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        attributedString.addAttribute(
            NSAttributedStringKey.underlineColor,
            value: kColor_Black,
            range: NSRange(location: 0, length: text.count)
        )
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func callLine(_ text : String) {
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedStringKey.underlineStyle,
            value: NSUnderlineStyle.styleThick.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        attributedString.addAttribute(
            NSAttributedStringKey.underlineColor,
            value: kColor_Black,
            range: NSRange(location: 0, length: text.count)
        )
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}
