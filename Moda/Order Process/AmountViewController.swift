//
//  AmountViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/22/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit


class AmountViewController: BaseViewController {
    
    var data: PaymentModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var completionHandler: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewProperties()
       
        setLabelProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }
    
    //MARK: -
    
    override func reloadTranslations() {
        
        navigationItem.title =  TR("payment_amount") //titleLabel.text = 
        frameLabel.text = TR("payment_amount_description")
        
        tableView.reloadData()
    }
    
    func setLabelProperties(){
        
        frameLabel.layer.borderColor = kColor_Black.cgColor;
        frameLabel.layer.borderWidth = 1.0;
    }
    
    func setViewProperties(){
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isOpaque = true
        
        
        navigationController?.navigationBar.layer.cornerRadius = 5
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.backgroundColor = .clear

    }
    
    
}

extension AmountViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let names = ["total_amount","payment_after"]
        
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_amount_type_1", for: indexPath)
            cell.layoutIfNeeded()

            cell.textLabel?.text = TR(names[indexPath.section])
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_amount_type_2", for: indexPath)
            cell.layoutIfNeeded()
 
            cell.textLabel?.text = TR(names[indexPath.section] + "_description")
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        if indexPath.section == 0 {
            self.data.amountType = .full
        } else {
            self.data.amountType = .zero
            self.data.paymentType = .cod
        }

        let nextVC = getVCFromMain("DeliveryDateViewController") as! DeliveryDateViewController
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
