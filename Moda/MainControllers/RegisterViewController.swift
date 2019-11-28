//
//  RegisterViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/9/18.
//  Copyright © 2018 moda. All rights reserved.
//

import GooglePlaces
import LUAutocompleteView
import SkyFloatingLabelTextField
import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var name: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var repassword: SkyFloatingLabelTextField!
    @IBOutlet weak var lastName: SkyFloatingLabelTextField!
    @IBOutlet weak var adress: SkyFloatingLabelTextField!
    @IBOutlet weak var phonePrefix: UILabel!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            self.signUpButton.layer.cornerRadius = 6
            self.signUpButton.clipsToBounds = true
        }
    }

    private let autocompleteView = LUAutocompleteView()
    private var placesClient: GMSPlacesClient!

    
    //MARK: - View Controller
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        placesClient = GMSPlacesClient()

        setPropertiesOnTextFields([name, email, password, repassword, lastName, phoneNumber, adress])

        addKeyboardWillShowNotif()
        
        setAutocompleteViewProperties()
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        reloadTranslations()
    }
    
    //MARK: - setProperties
    
    
    func setAutocompleteViewProperties(){
        
        view.addSubview(self.autocompleteView)
        autocompleteView.textField = adress
        autocompleteView.dataSource = self
        autocompleteView.delegate = self
        autocompleteView.maximumHeight = 10.0
    }
    
    override func reloadTranslations() {
        
        navigationItem.title = TR("registration").uppercased()
        
        name.placeholder = TR("name")
        lastName.placeholder = TR("last_name")
        email.placeholder = TR("mail")
        password.placeholder = TR("password")
        repassword.placeholder = TR("repassword")
        adress.placeholder = TR("address")
        phonePrefix.text = kPhonePrefixDefault
        phoneNumber.placeholder = TR("phone")
        
        signUpButton.setTitle(TR("do_registration"), for: .normal)
    }
    
    func addKeyboardWillShowNotif(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
    }
    
    //MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let preferredHeight = view.frame.height - keyboardHeight - adress.frame.maxY
            autocompleteView.maximumHeight = preferredHeight
            view.layoutIfNeeded()
        }
    }
    
    override func textChanged(textField: UITextField) {
        
        switch textField {
        case name:
            name.errorMessage  = Validator.isValidName(textField.text, TR("wrong_name"))
            
        case email:
            email.errorMessage  = Validator.isValidEmail(textField.text)
            
        case password:
            password.errorMessage = Validator.isValidPassword(textField.text)
 
        case repassword:
            repassword.errorMessage = Validator.isValidRePassword(textField.text, password.text)

        case lastName:
            lastName.errorMessage  = Validator.isValidName(textField.text, TR("wrong_surname"))
            
        case phoneNumber:
            phoneNumber.errorMessage  = Validator.isValidPhone(textField.text)
            
        default:
            break
        }
    }
    
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        name.errorMessage = Validator.isValidName(name.text, TR("wrong_name"))
        lastName.errorMessage = Validator.isValidName(lastName.text, TR("wrong_surname"))
        phoneNumber.errorMessage = Validator.isValidPhone(phoneNumber.text)
        email.errorMessage = Validator.isValidEmail(email.text)
        password.errorMessage = Validator.isValidPassword(password.text)
        repassword.errorMessage = Validator.isValidRePassword(repassword.text, password.text)
        
        if (name.errorMessage == nil) && (lastName.errorMessage == nil)  &&
            (phoneNumber.errorMessage  == nil ) &&  (email.errorMessage  == nil ) &&
            (password.errorMessage == nil) && (repassword.errorMessage  == nil )
        {
            signInRequest()
        }
    }
    
    func signInRequest() {
        
        addLightLoader()
        
        let parameters: [String : Any] =  [ "name" : name.text!,
                                        "address" : adress.text!,
                                        "surname" : lastName.text!,
                                        "email" :  email.text!,
                                        "phone" : kPhonePrefixDefault + phoneNumber.text!,
                                        "password" : password.text! ]
        
        NetworkManager.shared.postRegisterData(parameters, errorFunction: showAlertFromNet) { loginData in
 
            self.removeBlurredLoader()
            
            _ = editLocalToken(loginData.token, expired: loginData.expired)
            
            self.setVC("ProfileViewController")
         }
    }
    
    
}



// MARK: - LUAutocompleteViewDataSource

extension RegisterViewController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView,
                          elementsFor text: String,
                          completion: @escaping ([String]) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = kCountryDefault
        
        placesClient.autocompleteQuery(text, bounds: nil, filter: filter) { results, error in
            if let error = error {
                showErrorAnswerFromNet(#function, error.localizedDescription)
            } else
                if let results = results {
                    completion(results.map { $0.attributedFullText.string })
            }
        }
    }
}

// MARK: - LUAutocompleteViewDelegate

extension RegisterViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        
    }
}

