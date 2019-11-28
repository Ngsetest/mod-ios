//
//  PaymentMethodViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/17/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class PaymentMethodViewController: BaseViewController {
 
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    
    var data: PaymentModel!
    var completionHandler: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }
    
    
    override func reloadTranslations() {
        
       navigationItem.title = TR("lbl_payment_type")
        
    }
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesOfPaymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_payment", for: indexPath)
        cell.layoutIfNeeded()

        let name_line = namesOfPaymentTypes[indexPath.row]
        
        cell.textLabel?.text = kEmpty // name_line.capitalizingFirstLetter()
        cell.imageView?.image = UIImage(named: name_line)
        
        
        //TODO: - create if other payments method would be available
        cell.isUserInteractionEnabled = indexPath.row == 0
        cell.imageView?.layer.opacity =  indexPath.row > 0 ? 0.4 : 1.0
        
        return cell
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0: // PayMe
            
            let nextVC = getVCFromMain("PayViewController") as! PayViewController
            
            nextVC.completionHandler = { [weak self]
                (isReady) -> Void in
                if let callback = self?.completionHandler {
                    callback (isReady)
                }
            }
            
            data.paymentType = .payme
            nextVC.data = data
            
            showVC(nextVC)
            
        default:
            
            break
        }
        
    }
}
