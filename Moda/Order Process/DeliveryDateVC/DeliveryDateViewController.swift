//
//  DeliveryDateViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/18/18.
//  Copyright © 2018 moda. All rights reserved.
//

import DatePickerCell
import UIKit

class DeliveryDateViewController: BaseViewController {
    var data: PaymentModel!
    var completionHandler: ((Bool)->Void)?
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subTitleLabel : UILabel!
 
    @IBOutlet weak var tableView : UITableView!

    @IBOutlet weak var onSend : UIButton!{
        didSet{
            self.onSend.layer.cornerRadius = 6
            self.onSend.clipsToBounds = true
        }
    }

    
    @IBOutlet weak var descriptionLabel : UILabel!

    // Private of TableView
    
    var cells = [[DatePickerCell]]()
    
    var model : DateModel? {
        didSet {
            if let model = model {
                let date = model.methods[DeliveryType.IN_HOUR.name]!.date.getDateFromString()
                timeString = kTimeIntervals[0]
                dateString = date.fromDateToString()
            }
        }
    }
    
    var dateString: String? { didSet { tableView.reloadData() }  }
    var timeString: String? { didSet { tableView.reloadData() }  }
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        setTableViewProperties()
 
        requestDatesData()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }
    
    
    //MARK: - Actions
    
    @IBAction func goNext(_ sender: UIButton) {
 
        if let day = dateString, let time = timeString {
            data.dateLine  = "\(day), \(time)"
        }
 
        let nextVC = getVCFromMain("PrePaymentStep")  as! PrePaymentStep
        nextVC.data = data
        nextVC.completionHandler = { [weak self]
            (isReady) -> Void in
            if let callback = self?.completionHandler {
                callback (isReady)
            }
        }
        showVC(nextVC)
        
    }
    
    //MARK: - Functions
    
    func requestDatesData(){
        
        addBlurredLoader(with: getBlurredHeightForFull())
        
        getDeliveryModel {
            self.model = modelForDelivery!
            self.removeBlurredLoader()
        }
 
    }
    
    override func reloadTranslations() {
 
        navigationItem.title = TR("delivery_date")
        subTitleLabel.text = TR("specify_delivery_time")

        let niceCurrancyPrice = setNiceCurrancy( getDeliveryPrice(for: .IN_HOUR) )
        descriptionLabel.text = String(format: TR("delivery_price_description"), niceCurrancyPrice)
        
        onSend.setTitle(TR("continue"), for: .normal)
 
        tableView.reloadData()
    }
    
    
}
