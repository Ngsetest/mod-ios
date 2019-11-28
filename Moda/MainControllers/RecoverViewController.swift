//
//  RecoverViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/14/18.
//  Copyright © 2018 moda. All rights reserved.
//

import SkyFloatingLabelTextField
import UIKit

class RecoverViewController: BaseViewController {
    
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonSend: UIButton!
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
 
        setPropertiesOnTextFields([email])

        setBarButtonProperties()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
    }
 
    //MARK: - Actions
    
    @IBAction func recoverPassword(_ sender: UIButton) {
        
        email.errorMessage = Validator.isValidEmail(email.text)
        
        if email.errorMessage  == nil
        {
            email.endEditing(true)
            
            addLightLoader()
            
            NetworkManager.shared.postRecoverPassword(email.text!, errorFunction: showAlertFromNet) { model in
 
                self.removeBlurredLoader()

                self.showAlert(model.message)
            }
        }

    }
    
    
    @objc func didPressDoneButton() {
        
    }
    
    override func textChanged(textField: UITextField) {
        
        email.errorMessage  =  Validator.isValidEmail(textField.text)
    }
    
    override func reloadTranslations() {
        
        navigationItem.title = TR("password_recover")
        email.placeholder = TR("mail")
        buttonSend.setTitle(TR("do_password_recover"), for: .normal)
    }
    
    func setBarButtonProperties(){
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(title: TR("cancel").uppercased(), style: .done, target: self, action: #selector(didPressDoneButton))
        doneButton.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont(name: kFont_bold, size: 15)!],
            for: UIControlState.normal
        )
        
        doneButton.tintColor = kColor_Black
        
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.barStyle = .default
        
        toolBar.items = [flexsibleSpace, doneButton]
        toolbarItems = toolBar.items
        email.inputAccessoryView = toolBar
    }
}
