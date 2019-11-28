//
//  MyOrderDetailTableViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 26.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class MyOrderDetailTableViewController: BaseTableViewController {
    var data: MyOrderModel? {
        didSet {
            reloadTranslations()
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: -  Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //TODO: - Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.registerTableViewCell()
        
        tableView.allowsSelection = true
        self.navigationController?.navigationBar.isHidden = false
        
        reloadTranslations()
    }
 
    
    override func reloadTranslations() {
        title = TR("order_info").uppercased() + (data != nil ? " № \(data!.id)" : kEmpty)
    }
    
    // MARK: - Table delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        switch indexPath.section {
            
        case 0:
            
            let productVC = getVCFromMain("ProductViewController") as! ProductViewController
            productVC.productShortData =  data?.products[indexPath.row].getShortProduct()
            showVC(productVC)
            
        case 2:
            openWebPageFrom(NetworkManager.baseURL + middleSupportLinks[indexPath.row], middleSupportLabels[indexPath.row])

        default:
            break
        }
 
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            guard self.data != nil else { return 0 }
            return self.data!.products.count
        case 1:
            return 1
        case 2:
            return middleSupportLabels.count
        default:
            return 0
        }
        
    }
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 120
        case 2:
            return 44
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderInfoTableViewCell.identifier,
                                                     for: indexPath) as! MyOrderInfoTableViewCell
            cell.selectionStyle = .none
            let myOrderProduct: MyOrderProduct = self.data!.products[indexPath.row]
            cell.myOrder = myOrderProduct
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryPriceTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryPriceTableViewCell
            cell.selectionStyle = .none
            cell.setUpCellWithData(data!)
            cell.backgroundColor = kColor_AppLightGrayTag
            
            return cell
        
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_info", for: indexPath)
            cell.textLabel?.text = TR(middleSupportLabels[indexPath.row])
            
            return cell
        
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonSupportTableViewCell.reuseIdentifier, for: indexPath) as! ButtonSupportTableViewCell
            return cell
        }
    }

    
    func registerTableViewCell(){
        tableView.register(UINib(nibName: MyOrderInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MyOrderInfoTableViewCell.identifier)
        tableView.register(UINib(nibName: OrderSummaryPriceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderSummaryPriceTableViewCell.identifier)
    }

}
