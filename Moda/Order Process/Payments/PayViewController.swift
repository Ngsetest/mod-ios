//
//  PayViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/13/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Caishen
import UIKit
import Alamofire


class PayViewController: BaseViewController, UITextFieldDelegate {
    
    var url = NetworkManager.PaymentURL
 
    var data: PaymentModel!
    var dataVerification: JSONRpcVerifyCode!


    var order: MyOrderModel?
    var dataDelete: [Product]?
    private var token: String!
    private var orderId: Int!
    var completionHandler: ((Bool)->Void)?
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var card: CardTextField!
    @IBOutlet weak var pay: UIButton! {
        didSet {
            pay.layer.opacity = 0.0
            pay.layer.cornerRadius = 6
            pay.clipsToBounds = true 
            pay.isEnabled = false
        }
    }

  
    //MARK: - View Controllers

    override func viewDidLoad() {
        super.viewDidLoad()

        setCardSettings()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setNavBarItems()
 
        reloadTranslations()
    }
 
    //MARK: - Init Stuff

    override func reloadTranslations() {
        
        navigationItem.title = TR("payment")
        subTitleLabel.text = TR("enter_card_info")
    
        pay.setTitle(TR("make_payment"), for: .normal)
    }

     func setNavBarItems() {
        
        let image = UIImage(named: "payme")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    func setCardSettings(){
        
        card.keyboardAppearance = .light
        card.cardTextFieldDelegate = self
        card.cardTypeRegister.register(cardType: UzCardType())
    }

    //MARK: - Actions

    @IBAction func makePay(_ sender: UIButton) {
        
        sendOrder()
        
    }
    
    @IBAction func goToOffer(_ sender: UIButton) {
        
        _ = openUrlFrom(paymeOfferLink ,kEmpty)
    }
    
    //MARK: - PAYMENT STUFF

    
    private func sendOrder() {
 
        if let token = editLocalToken() {
            data.token = token
        }
        
        addLightLoader()
        
        NetworkManager.shared.postOrder(data.createDictForJson(), errorFunction:showAlertFromNet)
        { model in
            
            if let modelF = model.first {
            
                self.orderId = modelF.id
                self.order = modelF
                self.cardCreate(with: modelF.id, amount: modelF.amount!)
            
            } else {
                
                self.showAlertFromNet(kErrorInnerStructure, "No order data")
            }
            
        }
        
        
    }
    
    private func cardCreate(with orderID: Int, amount summ: Double) {
        
        var params : [String: Any] = [ "id": orderID,
                                       "method": "cards.create"]

        params["params"] =  [ "amount": summ,
                              "save": false,
                              "card": [
                                "number": card.numberInputTextField.text!.replacingOccurrences(of: " - ", with: kEmpty),
                                "expire": card.monthTextField.text! + card.yearTextField.text! ]]
 
        
        NetworkManager.shared.postCardData(params, errorFunction: showAlertFromNet) { model  in

            guard model.error == nil else {
                self.showAlertFromNet( model.error!.code,  model.error!.message)
                return
            }
            
            self.token = model.result!.card.token
            self.cardGetVerifyCode(with: self.token!, to: orderID)
        }
     
    }

    private func cardGetVerifyCode(with token: String, to orederID: Int) {
 
        let params: [String: Any] = [
            "id": orederID,
            "method": "cards.get_verify_code",
            "params": [
                "token": token
            ]
        ]
        
        NetworkManager.shared.postCardVerification(params, errorFunction: showAlertFromNet) { model  in
            

            if model.result.sent == nil  {
                
                self.showAlertFromNet(kErrorInnerStructure, "no result")
                
            } else {
                
                self.dataVerification = model
                self.showAlertForCodePut()
                
            }
            
        }
 
    }

    private func cardVerify(with token: String, to orederID: Int, and verifyToken: String) {
 

        let params: [String: Any] = [
            "id": orederID,
            "method": "cards.verify",
            "params": [
                "token": token,
                "code": verifyToken
            ]
        ]
        
        addLightLoader()
        
        NetworkManager.shared.postCardDataVerify(params, errorFunction:showAlertFromNet)
        { model  in
            
            guard model.error == nil else {
                self.showAlertFromNet(model.error!.code, model.error!.message)
                return
            }
            
            self.token = model.result!.card.token
            
            if model.result!.card.verify == nil  {
                
                self.showAlertFromNet(kErrorInnerStructure, "not verified")

            } else {
                
                if let order: MyOrderModel = self.order {
                    
                    self.sendPayment(order: order)
                
                } else {
                
                    self.showAlertFromNet(kErrorInnerStructure, "no orderModel")
                
                }
            }
        }
        
    }


    private func sendPayment( order: MyOrderModel) {
        
        let params :  [String : Any] =  [ "order_id": orderId, "token:": token ]
        
        NetworkManager.shared.postPayment(params, errorFunction: showAlertFromNet) { model  in
            
            if model.status  {
                self.showAlertPaymentReadyFor()
            } else {
                self.showAlertFromNet(kErrorInnerStructure, model.message)
            }
         }
    }
    
}

//MARK: - ALERTS

extension PayViewController {
    
    func showAlertForCodePut(){
        
        removeBlurredLoader()

        
        let alertController = UIAlertController(
            title: TR("put_in_code"),
            message: String(format: TR("sms_was_sent_with_code") , dataVerification.result.phone ?? "***"),
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = TR("code_for_check")
            textField.delegate = self
        }
        
        alertController.addAction(UIAlertAction(title: TR("ready").uppercased(), style: .default, handler: { action in
            guard alertController.textFields!.first!.text!.count == 6 else {
                
                self.showAlert(TR("wrong_number"))
                return
                
            }
            self.cardVerify(with: self.token, to: self.orderId, and: alertController.textFields!.first!.text!)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertPaymentReadyFor(){
        
        removeBlurredLoader()
 
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
}


//MARK: - CardTextFieldDelegate

extension PayViewController: CardTextFieldDelegate {
    
    func cardTextField(_ cardTextField: CardTextField, didEnterCardInformation information: Card, withValidationResult validationResult: CardValidationResult) {
        if validationResult == .Valid {
            data.cardNumber = cardTextField.numberInputTextField.text?.replacingOccurrences(of: " - ", with: kEmpty)
            
            let s =  card.monthTextField.text! + card.yearTextField.text!
            
            data.expire = s.replacingOccurrences(of: "/", with: kEmpty)
            UIView.animate(withDuration: 0.3) {
                self.pay.layer.opacity = 1.0
                self.pay.isEnabled = true
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.pay.layer.opacity = 0.0
                self.pay.isEnabled = false
            }
        }
    }

    func cardTextFieldShouldShowAccessoryImage(_ cardTextField: CardTextField) -> UIImage? {
        return nil
    }

    func cardTextFieldShouldProvideAccessoryAction(_ cardTextField: CardTextField) -> (() -> ())? {
        return nil
    }
}

