//
//  ProcessOrderViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/17/18.
//  Copyright © 2018 moda. All rights reserved.
//
 import SkyFloatingLabelTextField
import UIKit

class ProcessOrderViewController: BaseViewController {
 
    // MARK: - Data
    var profile: LogInInfo? {
        didSet {
            ModaManager.shared.setProfile(profile)

            firstName.text = profile!.data.name
            lastName.text = profile!.data.surname
            email.text = profile!.data.email
            phoneNumber.text = profile!.data.phone
            data.userId = profile!.data.id
        }
    } 
    var data = PaymentModel()
    var completionHandler: ((Bool)->Void)?
    
    // MARK: - Outlets

    @IBOutlet weak var downChevron: UIImageView!
    @IBOutlet weak var firstName: SkyFloatingLabelTextField!
    @IBOutlet weak var lastName: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var phonePrfix: UILabel!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var subsrcribe: UISwitch!
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subsrcribeLable: UILabel!

    @IBOutlet weak var onSend: UIButton!{
        didSet{
            self.onSend.layer.cornerRadius = 6
            self.onSend.clipsToBounds = true
        }
    }

    // MARK: - View Controller
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setPropertiesOnTextFields([firstName, lastName, email, phoneNumber])

        setLayersProperties()
        
        postProfileDataRequest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        reloadTranslations()
    }
     
    // MARK: - Actions
    
    
    @IBAction func closeView(_ sender: UIButton) {
        
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func goNext(_ sender: UIButton) {
        
        firstName.errorMessage = Validator.isValidName(firstName.text, TR("wrong_name"))
        lastName.errorMessage = Validator.isValidName(lastName.text, TR("wrong_surname"))
        phoneNumber.errorMessage = Validator.isValidPhone(phoneNumber.text)
//        email.errorMessage = Validator.isValidEmail(email.text)
        
        if (firstName.errorMessage == nil) && (lastName.errorMessage == nil)  &&
            (phoneNumber.errorMessage  == nil )// &&  (email.errorMessage  == nil )
        {
            onGoToNextController()
            
        }
        
    }
    
    func onGoToNextController(){
        
        data.firstName = firstName.text
        data.lastName = lastName.text
        data.email = email.text
        data.phoneNumber = phoneNumber.text
        data.subsrcribe = subsrcribe.isOn
        
        let nextVC = getVCFromMain("AddressViewController") as! AddressViewController
        
        nextVC.data = data
        
        if let pr : LogInInfo = self.profile {
            nextVC.profile = pr
        }
        
        nextVC.completionHandler = { [weak self]
            (isReady) -> Void in
            if let callback = self?.completionHandler {
                callback (isReady)
            }
            
            self?.dismiss(animated: false, completion: nil)
        }
        
        showVC(nextVC)
    }

    
    // MARK: - functions and methods
 
    override func reloadTranslations() {
        
        
        titleLabel.text = TR("checkout")
        subTitleLabel.text = TR("how_to_contact_you")
        subsrcribeLable.text = TR("do_subscribe")
        
        firstName.placeholder = TR("name")
        lastName.placeholder = TR("last_name")
        email.placeholder = TR("mail")
        phonePrfix.text = kPhonePrefixDefault
        phoneNumber.placeholder = TR("phone")
        
        
        onSend.setTitle(TR("continue"), for: .normal)
    }
    
    func postProfileDataRequest(){
        
        if let token = editLocalToken() {
            self.profileDataRequest(token)
        }
    }
    
    func setLayersProperties(){
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isOpaque = true
        navigationController?.navigationBar.layer.cornerRadius = 5
        navigationController?.navigationBar.clipsToBounds = true
    }
   
    override func textChanged(textField: UITextField) {
        
        switch textField {
        case firstName:
            firstName.errorMessage  = Validator.isValidName(textField.text, TR("wrong_name"))
            
//        case email:
//            email.errorMessage  = Validator.isValidEmail(textField.text)
//
        case lastName:
            lastName.errorMessage  = Validator.isValidName(textField.text, TR("wrong_surname"))
            
        case phoneNumber:
            phoneNumber.errorMessage  = Validator.isValidPhone(textField.text)
            
        default:
            break
        }
    }
    
    
    // MARK: - LOGIN
    
    private func profileDataRequest(_ token: String) {
        
        NetworkManager.shared.getLogInInfo(token, errorFunction: { code,  error   in
            
            debugLog(#function + kSemicolons +  error)
            
            _ = editLocalToken(kEmpty)
            
        }) {  model  in
            
            self.profile = model
            
 
        }
    }
    
}
