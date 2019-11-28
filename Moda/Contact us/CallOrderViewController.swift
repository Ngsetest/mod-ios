//
//  CallOrderViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 08.09.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
 
class CallOrderViewController: BaseViewController {

    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var callPrefix: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPropertiesOnTextFields([phoneTextField])

        if let logiInfo : LogInInfo = ModaManager.shared.getProfile() {
            
            self.phoneTextField.text = cutPrefixFromPhone(logiInfo.data.phone)

        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
    }
 
    
    override func reloadTranslations() {

        navigationItem.title = TR("order_call").capitalizingFirstLetter()
        
        phoneTextField.placeholder = TR("phone")
        infoLabel.text = TR("infoLabel_order_call")
        callPrefix.text = kPhonePrefixDefault
        sendButton.setTitle(TR("send"), for: .normal)
    }
    
    
    @IBAction func makeCall(_ sender: UIButton) {
        
        phoneTextField.errorMessage = Validator.isValidPhone( phoneTextField.text)
        
        
        if phoneTextField.errorMessage == nil {
            
            phoneTextField.resignFirstResponder()

            addLightLoader()
            
            NetworkManager.shared.postCallUsRequest(["phone": kPhonePrefixDefault + phoneTextField.text!],
                                                  errorFunction: showAlertFromNet)
            { line_answer in
                
                self.removeBlurredLoader()
                self.showAlertFromNet( line_answer)  
                
            }
            
        }
        
     }
    
   override func textChanged(textField: UITextField) {
        phoneTextField.errorMessage = Validator.isValidPhone( phoneTextField.text)
        
    }
}
