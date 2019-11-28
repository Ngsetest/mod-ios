//
//  OrderSummaryTableViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 26.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit
 
class OrderSummaryTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var completionHandler: ((Bool)->Void)?
    var paymentModel: MyOrderModel?
    var onceAlert = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearMemoryFromReadyOrder()

        registerTableViewCell()
       
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showThanksAlertOnce()
 
        navigationItem.title = TR("order_info")
        navigationItem.hidesBackButton = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"),style: .plain,
                                                            target: self,
                                                            action: #selector(OrderSummaryTableViewController.closeThisVC))

        
    }

    // MARK: - Table view data source
 
    
    @objc func closeThisVC() {
        
//        self.dismiss(animated: true) {
//                    }
        
        
        if let callback = self.completionHandler {
            callback (true)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
 
//        self.performSegue(withIdentifier: "unWindToMainZero", sender: self)
//        self.tabBarController?.selectedIndex = 0
    }
    
    
    func showThanksAlertOnce () {
        
        if onceAlert {
            
            showAlert( TR("we_will_connect"), title: TR("thanks_for_order"))
            onceAlert = false

        }
    }
    
    func registerTableViewCell(){
 
        tableView.register(UINib(nibName: OrderSummaryPriceTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: OrderSummaryPriceTableViewCell.identifier)
        
    }
    
}

extension OrderSummaryTableViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 5 {
            
            switch indexPath.row {
            case 0: callPhone()
            case 1: showVCFromName("MessageOrderViewController")
            default: break
            }
        }


    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            // ordered products
        case 2: return paymentModel?.products.count ?? 0
            
            // contact us buttons
        case 5: return 2
            
            // other informative cells
        default: return 1
        }
        
    }
    
}
