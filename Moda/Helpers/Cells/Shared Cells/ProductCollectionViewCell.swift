//
//  ProductCollectionViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/24/18.
//  Copyright © 2018 moda. All rights reserved.
//

import AlamofireImage
import UIKit

class ProductCollectionViewCell: BaseCollectionViewCell {

 
    
    // MARK: - Data

    var isHeart = false

    var isLarge = false
    
    private var changed: Bool!
    
    var data: Product? { didSet { updateUI() } }

    // MARK: - Outlets

    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var oldCurrency: UILabel!


    // MARK: - Layers

    let heart = CAShapeLayer()  
    private let new = CenteredCATextLayer()
    private let sale = CenteredCATextLayer()
    private let premium = CenteredCATextLayer()
    private let available = CenteredCATextLayer()

    // MARK: - LabelFlags

    var isNew = false { didSet { drawLabels() } }
    var isSale = false { didSet { drawLabels() } }
    var isPremium = false { didSet { drawLabels() } }
    var isFavorite = false
    var isAvailable = false { didSet { drawLabels() } }
    
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        [UIView]([preview, name, brand, currency, oldCurrency]).forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        } 
    }

    override func prepareForReuse() {
        data = nil

        new.removeFromSuperlayer()
        sale.removeFromSuperlayer()
        premium.removeFromSuperlayer()

        isNew = false
        isSale = false
        isPremium = false

        preview.image = nil
        brand.text = nil
        name.text = nil
        currency.text = nil
        oldCurrency.text = nil
        isLarge = false
        //deactivateAllConstraints()

        super.prepareForReuse()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        layoutIfNeeded()
        
        if isHeart{
            reloadFavoriteCollection(touches.first)
        } else {
            reloadNormalCollection(touches.first)
        }

    }
    
    func reloadHeart(){
        
        heart.drawHeart(in: bounds, isFilled : isFavorite)

    }
 
    func reloadNormalCollection(_ touch : UITouch?){
 
        guard let point = touch?.location(in: self) else { return }
        guard heart.path != nil else { return }
        guard data != nil else { return }

        var zoom = CGAffineTransform(scaleX: 2.5, y: 2.5)
        
        if heart.path!.copy(using: &zoom)!.contains(heart.convert(point, from: layer)) {
 
            editFavoriteList(products: [self.data!], addAction: !self.isFavorite, errorFunction: { error  in
                
                debugLog(error)
                
            }) { newArray in
                
                self.isFavorite = !self.isFavorite
                self.reloadHeart()

            }
            
        } else {
       
            openProductViewController()
 
        }
    }

    func reloadFavoriteCollection(_ touch : UITouch?){

        guard let point = touch?.location(in: self) else { return }
        guard heart.path != nil else { return }
        guard data != nil else { return }
        guard let vc = parentViewController as? FavoritesViewController else { return }
        
        var zoom = CGAffineTransform(scaleX: 2.5, y: 2.5)
        
        if heart.path!.copy(using: &zoom)!.contains(heart.convert(point, from: layer)) {
 
            editFavoriteList(products: [data!], addAction: false, errorFunction: { error  in
                
                debugLog(error)
                
            }) { newArray in
 
                for (index, value) in vc.data!.enumerated() {
                    if value == self.data! { vc.data!.remove(at: index) }
                }
                
                vc.collectionView.reloadData()
                
            }
            
            
        } else {
            
            openProductViewController()
            
        }
    }
    
    func openProductViewController(){
        
        let productVC = getVCFromMain("ProductViewController") as! ProductViewController
        productVC.productShortData = data?.getShortProduct()        
        changeVCInTabBarController(productVC) 
    }

    // MARK: - Private methods

    private func updateUI() {
        guard data != nil else { return }

        layoutIfNeeded()
        preview.image = nil
        loadNetImage( data!.image?.url, contentView, preview)

        name.text = data!.name
        brand.text = data!.brand.name.uppercased()
 
        // heart button
        reloadHeart()
        preview.layer.addSublayer(heart)

        setNicePrices(data!.getChoosenVariation(), &currency, &oldCurrency)

        isAvailable = data!.status == 1

    }

    private func drawLabels() {
        if isNew {
            new.drawNewLabel(
                in: CGRect(x: 0, y: 0, width: 195, height: 360 * 0.65),
                andColor: kColor_White
            )
            preview.layer.addSublayer(new)
        }
        if isSale {
            
            let variation = data?.getChoosenVariation()
            
            let price = variation?.price ?? 1
            
            if let price2 = variation?.price2  {
                if price2 > price {
                   
                    let percent = 100 - (price * 100) / price2
                    
                    sale.drawSaleLabel(
                        in: CGRect(x: 0, y: 0, width: 195, height: 360 * 0.65),
                        andColor: kColor_AppOrange,
                        percent: "-\(String(percent))%"
                    )
                    preview.layer.addSublayer(sale)
                    
                }
            }
          
        }
        if isPremium {
            premium.drawPremiumLabel(
                in: CGRect(x: 0, y: 0, width: 195, height: 360 * 0.65),
                andColor: kColor_AppBlack
            )
            preview.layer.addSublayer(premium)
        }
        
        if isAvailable {
//            self.available.drawAvailableLabel(
//                in: CGRect(x: 0, y: 0, width: 150, height: 360 * 0.65),
//                andColor: .white)
//            self.preview.layer.addSublayer(self.available)
        }
    }
}

// MARK: - Helpers extensions

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    func removeConstraints() {
        removeConstraints(constraints)
    }

    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(getAllConstraints())
    }

    func getAllSubviews() -> [UIView] {
        return UIView.getAllSubviews(view: self)
    }

    func getAllConstraints() -> [NSLayoutConstraint] {
        var subviewsConstraints = getAllSubviews().flatMap { (view) -> [NSLayoutConstraint] in
            return view.constraints
        }

        if let superview = superview {
            subviewsConstraints += superview.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
                if let view = constraint.firstItem as? UIView {
                    if view == self {
                        return constraint
                    }
                }
                return nil
            }
        }

        return subviewsConstraints + constraints
    }

    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { subView -> [UIView] in
            [subView] + getAllSubviews(view: subView)
        }
    }
}
