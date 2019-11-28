//
//  TrashItemCollectionViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/13/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import UIKit

class ShoppingBagItemTableViewCell: BaseImageTableViewCell {
 
    
    var previewLeadingConstraint: NSLayoutConstraint!
    var price: Int!
    var isSelectedToDelete = false
    
    // MARK: - Outlets


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var fullCurrency: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var idProduct: UILabel!

    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!

    
    @IBOutlet weak var selectImage: UIButton! {
        didSet {  selectImage.alpha = 0.0  }
    }
    
    
    var cellData: Product? {
        didSet {
            if let data = cellData {
            
                setAllLabels(data)
                setFullCurrency(data.count ?? 1)
            }
        }
    }
    
    
    // MARK: - Inits

    override func awakeFromNib() {
        super.awakeFromNib()
        
        reloadTranslations()
        
        reloadViewsPositions()
    }

    override func prepareForReuse() {

        productImage()?.image = nil

        name.text = nil
        brand.text = nil
        category.text = nil
        currency.text = nil
        countLabel.text = nil
        fullCurrency.text = nil
        colorName.text = nil
        cellData = nil
        idProduct.text = nil
        buttonPlus.isHidden = true
        buttonMinus.isHidden = true
        super.prepareForReuse()
    }
    
    func setAllLabels(_ product : Product!){
        
        let variation = product.getChoosenVariation()

        price =  variation.price
        name.text = product.name
        brand.text = product?.brand.name.uppercased()
        category.text = product?.category.name
        size.text = product?._size?.name
        colorName.text = TR("color") + kSemicolons +  product!.color!.name
        currency.text = setNiceCurrancy(variation.price)
        countLabel.text = kEmpty
        idProduct.text = " "//# \(product!.sku ?? kEmpty)"
        
        loadImage( product.image?.url)

    }

    func setLabelsForSummary(){
        
        let product  = cellData!
        let variation = product.getChoosenVariation()
        
        if product.count != nil && product.count! > 1 {
            currency.text = setNiceCurrancy(variation.price) + "   ( \(product.count!) " + TR("pcs") + " )"
            countLabel.text = setNiceCurrancy( product.count! * variation.price)
        } else {
            currency.text = setNiceCurrancy(variation.price)
            countLabel.text = kEmpty

        }
        
        countLabel.textAlignment = .left
        fullCurrency.text = kEmpty

    }
    
    
    // MARK: - Actions

    @IBAction func selected(_ sender: UIButton) {
        
        guard let vc = parentViewController as? ShoppingBagViewController, vc.isEditMode else { return }

        vc.onSelectItem(self)
        
    }
 
    @IBAction func stepperValueChanged(_ button: UIButton) {
 
        let count = cellData!.count! + (button == buttonMinus ? -1 : 1)
        
        guard  count > 0  else { return }
        
        cellData?.count = count

        setFullCurrency(count)
        
        (parentViewController as? ShoppingBagViewController)?.onSteppersButtons(cellData!)

 
    }

    
    func setFullCurrency(_ count : Int){
        
        countLabel.text = "\(count) " + TR("pcs")
        fullCurrency.text = setNiceCurrancy( count * price) 
        
    }

}
