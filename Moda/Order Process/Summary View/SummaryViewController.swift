//
//  SummaryViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/17/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit
 
class SummaryViewController: BaseViewController {
    
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


    @IBOutlet weak var containerHeight: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewProperties()

        setNavProperties()
 
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    override func reloadTranslations() {
        
        navigationItem.title = TR("information_about_order")
        onSend.setTitle(TR("continue"), for: .normal)
        
        tableView.reloadData()
    }
    
    func setTableViewProperties(){
        
        containerHeight.constant = getContainerHeight(on: (data.orders!.count))

        tableView.register(UINib(nibName:  ShoppingBagItemTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ShoppingBagItemTableViewCell.identifier)
        tableView.register(UINib(nibName:  PeopleInfoStaticTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PeopleInfoStaticTableViewCell.identifier)
        tableView.register(UINib(nibName: OrderInfoTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: OrderInfoTableViewCell.identifier)
    }
    

    
    func setNavProperties(){
        
        view.layoutIfNeeded()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isOpaque = true
        
        navigationController?.navigationBar.layer.cornerRadius = 5
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func getContainerHeight(on count: Int) -> CGFloat {
        let headers: CGFloat = 35.5 * 2 + 55
        let firstCells: CGFloat = 195.0 + 190.0
        let secondCells: CGFloat = CGFloat(count * 200)
        return headers + firstCells + secondCells
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
        

        if data.paymentType == .cod {

            sendOrder()

        }
        else {
            
            openPaymentForms()
        }
        
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
    

    func openPaymentForms(){
        
        let nextVC = getVCFromMain("PaymentMethodViewController") as! PaymentMethodViewController
        nextVC.data = data
        
        nextVC.completionHandler = { [weak self]
            (isReady) -> Void in
            if let callback = self?.completionHandler {
                callback (isReady)
            }
        }
        showVC(nextVC)
    }
}

extension SummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return self.data.orders!.count }
        else { return 1 }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell( withIdentifier: PeopleInfoStaticTableViewCell.identifier,
                for: indexPath ) as! PeopleInfoStaticTableViewCell
            cell.selectionStyle = .none
            cell.setUpCellWithData(data)
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell( withIdentifier: OrderInfoTableViewCell.identifier,
                for: indexPath ) as! OrderInfoTableViewCell
            cell.selectionStyle = .none
            cell.setUpCellWithData(data)
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell( withIdentifier: ShoppingBagItemTableViewCell.identifier,
                for: indexPath) as! ShoppingBagItemTableViewCell
            cell.selectionStyle = .none

            cell.cellData = data!.orders![indexPath.row]
            cell.setLabelsForSummary()
            
            return cell
        }
    }
    

}



extension SummaryViewController: UITableViewDelegate {
    
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            case 0:  return 195
            case 1:  return 190
            default: return 200
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:  return nil
            case 1:  return nil
            default: return TR("goods") + " (\(self.data.orders!.count))"
        }
 
    }
    
}
