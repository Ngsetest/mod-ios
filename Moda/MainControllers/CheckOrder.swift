//
//  CheckOrder.swift
//  Moda
//
//  Created by admin_user on 11/4/18.
//  Copyright © 2018 moda. All rights reserved.
//
//

import SkyFloatingLabelTextField
import UIKit

class CheckOrder: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var line: SkyFloatingLabelTextField!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var statusLabel: UITextView!
    @IBOutlet weak var buttonSend: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setPropertiesOnTextFields([line])

        setStatusLabelProperties()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        removeBlurredLoader()
 
        reloadTranslations()
    }
  
    
    func setStatusLabelProperties(){
        
        statusLabel.layer.cornerRadius = 4
        statusLabel.layer.borderWidth  = 1
        statusLabel.layer.borderColor  = kColor_DarkGray.cgColor
        statusLabel.text = kEmpty
        statusLabel.layer.opacity = 0
        
    }
    
    
    override func reloadTranslations() {
        
        title = TR("check_order_status").uppercased()
        
        line.placeholder = TR("order_number")
        buttonSend.setTitle(TR("check_order_status"), for: .normal)
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .font :  UIFont.init(name: kFont_normal, size: 15)!,
            .foregroundColor: kColor_DarkGray
        ]
        
        
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: NetworkManager.baseURL + supportContactsLink + linkTail)!,
            .font :  UIFont.init(name: kFont_normal, size: 15)!,
            .foregroundColor : kColor_Blue
        ]
        
        let textMain = NSMutableAttributedString(string: TR("co_text_if_something_1"), attributes: textAttributes )
        let textLink = NSMutableAttributedString(string: TR("co_text_if_something_2"), attributes: linkAttributes )

        textMain.append(textLink)
        
        textLabel.attributedText = textMain
 
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        
         line.errorMessage =  Validator.isValidOrderNumber(line.text)
      
        if line.errorMessage == nil{
 
            line.resignFirstResponder()
 
            sendRequest()
        }
    }
    
    
    override func textChanged(textField: UITextField) {
        
       line.errorMessage = Validator.isValidOrderNumber(textField.text)
    
    }
    
    private func sendRequest() {
        
       let orderId = line.text!
        
        addLightLoader()
        
        NetworkManager.shared.getChekOrder(orderId, errorFunction: showAlertFromNet) { data in
            
            self.removeBlurredLoader()
            self.showStatus(orderId, data.status)
                
        }
  
    }

    func showStatus(_ orderId : String, _ text : String){
 
        let textAttributes: [NSAttributedStringKey: Any] = [
            .font :  UIFont.init(name: kFont_normal, size: 15)!,
            .foregroundColor: kColor_DarkGray
        ]
        
        let resultAttributes: [NSAttributedStringKey: Any] = [
            .font :  UIFont.init(name: kFont_medium, size: 15)!,
            .foregroundColor: kColor_Black
        ]
        
        let textAtributed = NSMutableAttributedString(string: TR("order_num") + " ", attributes: textAttributes)
        textAtributed.append(NSMutableAttributedString(string: orderId + " ", attributes: resultAttributes))
        textAtributed.append(NSMutableAttributedString(string: TR("status_") + " ", attributes: textAttributes))
        textAtributed.append(NSMutableAttributedString(string: text, attributes: resultAttributes))

        statusLabel.attributedText = textAtributed
        statusLabel.layer.opacity = 1
    } 

    // MARK: - TextViewDelegate
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        openWebPageFrom(URL.absoluteString, upperSupportTitle[0])
 
        return false
    }
    

    
}
