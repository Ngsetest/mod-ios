//
//  MyOrdersViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 25.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class MyOrdersViewController: BaseTableViewController {
    
    var data: [MyOrderModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        registerTableViewCell()
        myOrdersRequest()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "MyOrderDetails" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let vc:MyOrderDetailTableViewController = segue.destination as! MyOrderDetailTableViewController
                let model = self.data?[selectedRow]
                vc.data  = model
            }
        }
    }
    
    // MARK: - TableView
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 1 {
            return  middleSupportLabels.count
        }
        guard self.data != nil else { return 0 }
        return self.data!.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
            let myOrder:MyOrderModel = self.data![indexPath.row]
            cell.myOrder = myOrder
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_info", for: indexPath)
            cell.textLabel?.text = TR(middleSupportLabels[indexPath.row])
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonSupportTableViewCell.reuseIdentifier, for: indexPath) as! ButtonSupportTableViewCell
            // cell.supportTitle.text = noImageSupportTitle[indexPath.item]
            return cell
        }
    }
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        } else {
            return 44
        }    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let myOrder:MyOrderModel = self.data![indexPath.row]
            self.performSegue(withIdentifier: "MyOrderDetails", sender: ["myOrder":myOrder])
        }
        
        if indexPath.section == 1  {
            
            openWebPageFrom(NetworkManager.baseURL + middleSupportLinks[indexPath.row], middleSupportLabels[indexPath.row])

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerTableViewCell(){
        tableView.register(UINib(nibName: OrderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.identifier)
    }
    
    //MARK: -
    override func reloadTranslations() {
       
        title = TR("my_orders").uppercased()
    }
    
    private func myOrdersRequest() {
 
        guard let token = editLocalToken() else { return }
 
        NetworkManager.shared.getMyOrders(token, errorFunction: showAlertFromNet) { model  in

            self.data = model
            
        }
    }
    
}
    

