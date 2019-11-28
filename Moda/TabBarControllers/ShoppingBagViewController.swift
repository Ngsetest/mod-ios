//
//  ShoppingBagViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/30/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Caishen
import UIKit

class ShoppingBagViewController: BaseViewController {
    
    var selectedCells = [Product]()
    var isEditMode: Bool = false
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    

    // MARK: - Outlets
    
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var summ: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var buy: UIButton! {
        didSet{
            self.buy.layer.cornerRadius = 6
            self.buy.clipsToBounds = true
        }
    }
    @IBOutlet weak var changeButton: UIButton!

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyButton: UIButton!

    
    // MARK: - Data

    var data: [Product]? {
        didSet {
            if let _ = data {
                reloadFullSum()
                buy.isEnabled = fullSumm > 0
            }
            
            reloadEmpty()
        }
    }
 
    var fullSumm = 0 {
        didSet {
            summ.text =  TR("total") + " " + setNiceCurrancy(fullSumm)
        }
    }

    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlurredLoader(with: getBlurredHeight())
        
        setViewProperties()
        
        registerTableViewCells(tableView)
        tableView.separatorStyle = .none
        
        ModaManager.shared.getDiscountInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
 
        
        getShoppingBag()
        
    } 
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
 
        emptyView.isHidden = true
        
        reloadTranslations()
    }
    
    
    
    // MARK: - private
    
 
    override func reloadTranslations() {
 
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = TR("basket")

        tax.text = TR("tax_info_line")

        emptyLabel.text = TR("basket_empty")
        emptyButton.setTitle(TR("start_buy2"), for: .normal)
 
        
        if  isEditMode {
            switchNamesToDelete()
        } else {
            switchNamesToEdit()
        }
        
        if tax.layer.opacity == 1 {
            buy.setTitle(TR("buy"), for: .normal)
        }
        
    }
 
    func setViewProperties(){
        
        view?.layer.cornerRadius = 5
        view?.clipsToBounds = true
        view?.isOpaque = true
        
    }
    
    func isValid(_ digits: [Int]) -> Bool {
        return digits.reversed().enumerated().map { idx, item in
            if idx % 2 == 1 {
                let doubledValue = item * 2
                return doubledValue > 9 ? doubledValue - 9 : item
            }
            return item
            }.reduce(0, +) % 10 == 0
    }

    
    func reloadFullSum() {
        
        fullSumm = 0
        
        data?.forEach {
            fullSumm += $0.getChoosenVariation().price * $0.count!
        }

        itemsCount.text = data != nil ? TR("products_in_genitive") + ": \(data!.count )" : kEmpty

    }
    
    func switchNamesToDelete(){
        
        buy.setTitle(TR("delete"), for: .normal)
        changeButton.setTitle(TR("save"), for: .normal)
        changeButton.setTitleColor(kColor_AppOrange, for: .normal)
    }
    
    func switchNamesToEdit(){

        buy.setTitle(TR("buy"), for: .normal)
        changeButton.setTitle(TR("change"), for: .normal)
        changeButton.setTitleColor(kColor_AppBlack, for: .normal)

    }
    
    func selectForDelete(_ cell : ShoppingBagItemTableViewCell){
        cell.isSelectedToDelete = !cell.isSelectedToDelete
 
        if cell.isSelectedToDelete {
            
            cell.selectImage.alpha = 1.0
            selectedCells.append(cell.cellData!)
            
        } else {
            
            cell.selectImage.alpha = 0.5
            selectedCells.removeAll(where: { $0 == cell.cellData! })
         }
        
    }
    
    // MARK: - Actions
    
    func onSelectItem(_ cell : ShoppingBagItemTableViewCell){
        
        if  isEditMode {
            selectForDelete(cell)
        } else {
            
            let productVC = getVCFromMain("ProductViewController") as! ProductViewController
            let newProduct = cell.cellData?.getShortProduct()
            productVC.productShortData = newProduct
            showVC(productVC)
        }
        
    }

  
    func onSteppersButtons(_ cellData : Product ) {
  
        editBagList(products: [ cellData ], addAction: true, countAmount: false, errorFunction: { error in
            
            self.showAlert(error)
 
        }) { savedList in
            
            self.data = savedList

        }
        
        
    }
    
    @IBAction func onStartBuy(_ sender: UIButton) {
 
        tabBarController?.selectedIndex = 0

    }
    
    @IBAction func change(_ sender: UIButton) {
        
        if  isEditMode {
            isEditMode = false
            switchNamesToEdit()
        } else {
            isEditMode = true
            switchNamesToDelete()
        }

        if !self.data!.isEmpty { self.tableView.reloadData() }
    }
    
    func onAnswerRemoveItems(_ error : String){
        reloadEmpty()
    }

    @IBAction func buy(_ sender: UIButton) {
        
        if sender.titleLabel!.text == TR("delete") {
            
            guard !selectedCells.isEmpty else { return }
            guard data != nil else { return }
            

            editBagList(products: selectedCells, addAction: false, countAmount: false, errorFunction: onAnswerRemoveItems) { productInBag in
  
                self.selectedCells.removeAll()

                self.data = productInBag
                self.tableView.reloadData()
            }

        }

    }

    private func getShoppingBag(_ change: Bool = false) {
 
        editBagList(errorFunction: errorLoadShow, answerFunction: reloadTableView)
    }
    
    func errorLoadShow( _ error : String){
        showAlert(error)
        removeBlurredLoader()
    }
    
    func reloadEmpty(){
        
        let isEmpty = data?.isEmpty ?? true
        
        emptyView.isHidden = !isEmpty
        changeButton.isHidden = isEmpty
        
        if isEmpty {
            isEditMode = false
            switchNamesToEdit()
        }

    }
    
    func reloadTableView(_ shopingBag : [Product]) -> Void{
        
        
        data = nil
        data = shopingBag
        tableView.isHidden = data!.count == 0
        tableView.reloadData()
        removeBlurredLoader()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "uz.moda.Pay" && self.buy.titleLabel!.text == TR("delete") {
            return false
        }

        return true
    }

    private func registerTableViewCells(_ tableView: UITableView) {
        tableView.register(
            UINib(nibName: ShoppingBagItemTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ShoppingBagItemTableViewCell.identifier
        )
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ShoppingBagViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard data != nil else { return 0 }
        return data!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingBagItemTableViewCell.identifier,
            for: indexPath) as! ShoppingBagItemTableViewCell
 
        let product =  data?[indexPath.row]
        cell.cellData = product
        cell.isSelectedToDelete = selectedCells.contains(product!)
        cell.animate(revert: isEditMode)
        
        return cell
    }
 
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }

    @available(iOS 11.0, *)
    func tableView( _ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: TR("delete")) {
            (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
 
            guard let product = self.data?[indexPath.row] else { return }

            editBagList(products: [product], addAction : false, countAmount: false,
                        errorFunction: self.onAnswerRemoveItems,
                        answerFunction: self.reloadTableView)
        }
        
        deleteAction.backgroundColor = kColor_Black

        return  UISwipeActionsConfiguration(actions: isEditMode ? [] : [deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShoppingBagItemTableViewCell {
            onSelectItem(cell)
        }
    }
}

extension ShoppingBagViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(
            viewController: self,
            presentingViewController: segue.destination
        )
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
        
        let navCon = segue.destination as! UINavigationController
        let payVC = navCon.viewControllers.first! as! ProcessOrderViewController
        
        payVC.completionHandler = { [weak self]
            (isReady) -> Void in
            
            if isReady {
                
                editBagList(products: nil, addAction: true, errorFunction: { error in
                    
                    showErrorAnswer("ShoppingBagViewController:prepare", nil, errorLine : error)
                    
                }, answerFunction: { newList in
                    
                    self?.tabBarController?.selectedIndex = 0
                    
                })
            }
        }
        
        payVC.data.orders = data
        payVC.data.fullPrice = fullSumm
    }
}
