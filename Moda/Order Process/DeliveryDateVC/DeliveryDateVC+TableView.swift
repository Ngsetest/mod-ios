//
//  DeliveryDateVC+TableView.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/18/18.
//  Copyright © 2018 moda. All rights reserved.
//

import DatePickerCell
import UIKit

protocol  FCustomDateDelegation: class {
    func youHaveChoosed(date:String, type:Int)
}

extension DeliveryDateViewController: UITableViewDataSource, UITableViewDelegate,FCustomDateDelegation {
 
    func setTableViewProperties() {
        
        tableView.rowHeight = UITableViewAutomaticDimension 
        tableView.tableFooterView = UIView()
        tableView.register(DeliveryTableViewCell.self,forCellReuseIdentifier: DeliveryTableViewCell.identifier)
 
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = FChooseDateViewController()
        
        if indexPath.section == 0 {
            viewController.viewTitleString = TR("choose_delivery_date")
            viewController.arrayOfDate = model?.methods[DeliveryType.IN_HOUR.name]?.date.getDateFromString().fiveDaysArray()
        }
        
        if indexPath.section == 1 {
            viewController.viewTitleString = TR("choose_delivery_interval")
            viewController.arrayOfDate = kTimeIntervals
        }
        
        viewController.customDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTableViewCell.identifier, for: indexPath) as! DeliveryTableViewCell
 
        if indexPath.section == 0 {
            
            if let day = dateString {
               cell.dateLabel.text = day
            }
            return cell

        }
 
        cell.titleHeader.text = TR("choose_interval")
        
        if let time = timeString {
            cell.dateLabel.text = time
        }
        return cell
        
    }
    
    //Custom Delegation FIXME
    
    func youHaveChoosed(date: String, type: Int) {
        if type == 0 {
            self.dateString = date
        } else {
            self.timeString = date
        }
    }

}
