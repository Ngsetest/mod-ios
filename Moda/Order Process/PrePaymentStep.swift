//
//  PrePaymentStep.swift
//  Moda
//
//  Created by admin_user on 7/11/19.
//  Copyright © 2019 moda. All rights reserved.
//


import UIKit

class PrePaymentStep: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: PaymentModel!
    var completionHandler: ((Bool)->Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var onSend: UIButton!{
        didSet{
            self.onSend.layer.cornerRadius = 6
            self.onSend.clipsToBounds = true
        }
    }

    
    var canPayAfterDelivery = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
        canPayAfterDelivery = getDiscountedPrice() < Double(kMaxOnlinePayment)
       
        if !canPayAfterDelivery {
            data.paymentType = .visa
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func reloadTranslations() {
        
       navigationItem.title = TR("information_about_order")
        onSend.setTitle(TR("continue"), for: .normal)
        
        tableView.reloadData()
    }
    
    //MARK: -  Actions
    
    func showOrderSummary (order: MyOrderModel) {
        
        let vc = getVCFromMain("OrderSummaryController") as! OrderSummaryTableViewController
        vc.completionHandler = { [weak self]
            (isReady) -> Void in
            if let callback = self?.completionHandler {
                callback (isReady)
            }
        }
        vc.paymentModel = order
        showVC(vc)
        
    }
    
    @IBAction func goNext(_ sender: UIButton) {
 
        let vc = getVCFromMain("SummaryViewController") as! SummaryViewController
        vc.data = data
        vc.completionHandler = { [weak self]
            (isReady) -> Void in
            if let callback = self?.completionHandler {
                callback (isReady)
            }
        }
        showVC(vc)
        
    }
    
    
    func sendOrder() {
        
        if let token = editLocalToken() {
            self.data.token = token
        }
        
        addLightLoader()
        
        NetworkManager.shared.postOrder(data!.createDictForJson(), errorFunction:showAlertFromNet)
        { model in
            
            if (model.count > 0) && (model.first!.id > 0) {
                
                self.removeBlurredLoader()
                self.showOrderSummary(order: model.first!)
                
            } else {
                
                self.showAlertFromNet(kErrorInnerStructure, "No order data")
                
            }
        }
    }
    
    
    //MARK: - TableView
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                if canPayAfterDelivery {
                    data.paymentType = .cod
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath(row: 1, section: 1)], with: .automatic)
                }
                
                break
            case 1:
                
                data.paymentType = .visa
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath(row: 1, section: 1)], with: .automatic)
                
                break
            default:
                break
                
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0: return 1
        case 1: return 2
        default: return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell( withIdentifier:"cell_id_1",
                                                      for: indexPath )
            cell.layoutIfNeeded()
            let contView = cell.contentView
            let label = contView.viewWithTag(100) as! UILabel
            label.text = TR("choose_payment_method")
            
            return cell
            
        case 1:
            
            if indexPath.row == 0 {
 
                let cell = tableView.dequeueReusableCell( withIdentifier:"cell_id_2",
                                                          for: indexPath )
                cell.layoutIfNeeded()
                let contView = cell.contentView
                let label = contView.viewWithTag(100) as! UILabel
                label.layer.cornerRadius = 4
                
                
                if canPayAfterDelivery {
                    label.text = TR("will_be_payed")
                    cell.accessoryType = data.paymentType == .cod ? .checkmark : .none
                } else {
                    label.text = kEmpty
                    cell.accessoryType =   .none
                }
                
                return cell
                
            } else {
            
                let cell = tableView.dequeueReusableCell( withIdentifier:"cell_id_3",
                                                          for: indexPath )
                cell.layoutIfNeeded()
                let contView = cell.contentView
                let label = contView.viewWithTag(100) as! UILabel
                label.text = TR("payment_with_card")
                label.layer.cornerRadius = 4
                cell.accessoryType = data.paymentType != .cod ? .checkmark : .none

                
                
                return cell
            }
 

        default:
            
            let cell = tableView.dequeueReusableCell( withIdentifier:"cell_id_4",
                                                      for: indexPath )
            cell.layoutIfNeeded()
            let contView = cell.contentView
            var label = contView.viewWithTag(10) as! UILabel
            label.text = TR("lbl_payment_amount")

            
            label = contView.viewWithTag(100) as! UILabel
            label.text = TR("goods_in_order")

            label = contView.viewWithTag(200) as! UILabel
            label.text = TR("goods_for_summ_in_order")
            
            label = contView.viewWithTag(300) as! UILabel
            label.text = TR("delivery")

            label = contView.viewWithTag(400) as! UILabel
            label.text = TR("discounts")
            
            label = contView.viewWithTag(500) as! UILabel
            label.text = TR("generally")
            
            var count_goods = Int(0)
            data.orders?.forEach({ product in
                count_goods += (product.count ?? 1)
            })
            
            label = contView.viewWithTag(110) as! UILabel
            label.text = "\(count_goods) " + TR("pcs")
            
            label = contView.viewWithTag(210) as! UILabel
            label.text =  setNiceCurrancy(data.fullPrice!)
            
            label = contView.viewWithTag(310) as! UILabel
            label.text = setNiceCurrancy(getDeliveryPrice(for: data.deliveryType!))
            
            let discountProc = ModaManager.shared.appDiscount ??  0
            label = contView.viewWithTag(410) as! UILabel
            label.text = "\(discountProc) %"
 
            label = contView.viewWithTag(510) as! UILabel
            label.text = setNiceCurrancy(getDiscountedPrice())
            
            
            
            
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 40
        case 1:  return 50
        default: return 200
        }
    }
 
    func getDiscountedPrice() -> Double {
        let discountProc = ModaManager.shared.appDiscount ??  0
        let fullPrice = getDeliveryPrice(for: data.deliveryType!) + data.fullPrice!

        return Double(fullPrice) * (100 - discountProc) / 100
    }
}


