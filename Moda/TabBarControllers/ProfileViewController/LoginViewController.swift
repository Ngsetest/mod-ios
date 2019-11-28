//
//  LoginViewController.swift
//  Moda
//
//  Created by admin_user on 8/17/19.
//  Copyright © 2019 mod. All rights reserved.
//

import SkyFloatingLabelTextField
import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
            self.loginButton.layer.cornerRadius = 6
            self.loginButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var passwordButton: UIButton!
    
    
    
    //MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPropertiesOnTextFields([email , password])
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func recoverPassword(_ sender: UIButton) {
        
        showVCFromName("RecoverViewController")
        
    }
    
    func openProfileVC(){
        
        setVC("ProfileViewController")
        
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        email.errorMessage = Validator.isValidEmail(email.text)
        password.errorMessage = Validator.isValidPassword(password.text)
        
        if   (email.errorMessage  == nil ) && (password.errorMessage == nil)
        {
            postLogInData()
        }
    }
    
    override func textChanged(textField: UITextField) {
        
        switch textField {
        case email:
            email.errorMessage = Validator.isValidEmail(textField.text!)
            
        case password:
            password.errorMessage =  Validator.isValidPassword(textField.text!)
            
        default:
            break
        }
    }
    
    
    func postLogInData() {
        
        self.loginButton.isEnabled = false
        
        let parameters:  [String : Any]  = ["email": email.text!,  "password": password.text!]
        
        addLightLoader()
        
        NetworkManager.shared.postLogInRequest(parameters, errorFunction: { code, error in
            
            self.loginButton.isEnabled = true
            
            self.showAlertFromNet(code, error)
            
        }) { loginModel in
            
            _ = editLocalToken(loginModel.token, expired: loginModel.expired)
            
            self.removeBlurredLoader()
            
            self.openProfileVC()
        }
        
    }
    
    // MARK: - Functions
    
    
    override func reloadTranslations() {
        
        
        navigationItem.title = TR("do_login")
 
        email.placeholder = TR("mail")
        email.keyboardType = .emailAddress
        
        
        password.placeholder = TR("password")
        
        loginButton.setTitle(TR("do_login"), for: .normal)
        passwordButton.setTitle(TR("forgot_password"), for: .normal)
 
        
    }
    
}
