//
//  OrderSummary_TableViewCell_s.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 26.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit


extension OrderSummaryTableViewController {
 
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
 
        let height : [CGFloat] = [89,124,120,112,85,60]
        
        return height[indexPath.section]
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryHeaderTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryHeaderTableViewCell
            cell.setOrder(paymentModel?.id )
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryAdressTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryAdressTableViewCell
            cell.setUpCellWithData(paymentModel!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryLotTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryLotTableViewCell
            let product: MyOrderProduct = (paymentModel?.products[indexPath.row])!
            cell.setUpCellWithData(product)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryPriceTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryPriceTableViewCell
            cell.setUpCellWithData(paymentModel!)
            cell.backgroundColor = kColor_AppLightGrayTag
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryInfoTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryInfoTableViewCell
            cell.setInfoLabel(paymentModel?.id)
            return cell 
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryConnectUsTableViewCell.identifier,
                                                     for: indexPath) as! OrderSummaryConnectUsTableViewCell
            
            switch indexPath.row {
            case 0:  cell.setCallView()
            case 1:  cell.setMailView()
            default: break
            }
            
            return cell
        }
    }
    
}

class OrderSummaryHeaderTableViewCell: BaseTableViewCell {
    
    func setOrder( _ idStr : Int?){
        
        getLabel(100)?.text = String(format: TR("your_order_num_completed"), idStr ?? 0)
        getLabel(200)?.text = TR("thanks")
    }
    
}

class OrderSummaryAdressTableViewCell: BaseTableViewCell {
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard let paymentModel = dataModel as? MyOrderModel else {  return }
        
        getLabel(100)?.text = " "
        
         getLabel(200)?.text = paymentModel.address
 
        getLabel(300)?.text = paymentModel.paymentMethod == .cod ?
            TR("will_be_payed") : TR("payment_with_card")
        
    }
    
}

class OrderSummaryLotTableViewCell: BaseImageTableViewCell {
    
    override func setUpCellWithData(_ dataModel: Any) {
        
        guard let product = dataModel as?  MyOrderProduct else {  return }
        
        loadImage(product.existing.image.url)
        
        getLabel(200)?.text = product.boutique + "\n" + (product.name ?? kEmpty)
        getLabel(300)?.text = TR("color") + kSemicolons +  product.color + "; "
            + TR("size") + kSemicolons +  product.size
        getLabel(400)?.text = setNiceCurrancy(Int(product.price!))
        getLabel(500)?.text = "\(product.quantity) " + TR("pcs")
        
        
    }
}

class OrderSummaryInfoTableViewCell: BaseTableViewCell {
    
    func setInfoLabel(_ idString : Int?){
        
        getLabel(100)?.text = String(format: TR("warning_after_order_completed"), idString ?? 0)
        
    }
}


class OrderSummaryConnectUsTableViewCell: BaseTableViewCell {
    
    func setCallView(){
 
        getImageView(100)?.image = UIImage(named: "call_phone_button_image")
        getLabel(200)?.text = TR("call_us")
        getButton(300)?.layer.borderColor = kColor_AppLightSilver.cgColor
        getButton(300)?.layer.backgroundColor = kColor_White.cgColor

    }
    
    func setMailView(){
        
        getImageView(100)?.image = UIImage(named: "mail_button_image")
        getLabel(200)?.text = TR("write_us")
        
        getButton(300)?.layer.borderColor = kColor_AppLightSilver.cgColor
        getButton(300)?.layer.backgroundColor = kColor_AppLightGrayTag.cgColor
        
    }
    
}
