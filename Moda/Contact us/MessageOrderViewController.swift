//
//  MessageOrderViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 08.09.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class MessageOrderViewController: BaseViewController,UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet {
            self.nameTextField.keyboardType = .namePhonePad
            self.nameTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            self.emailTextField.keyboardType = .emailAddress
            self.emailTextField.delegate = self
        }
    }
    @IBOutlet weak var messageTitleTextField: UITextField!{
        didSet {
            self.messageTitleTextField.keyboardType = .alphabet
            self.messageTitleTextField.delegate = self
        }
    }
    @IBOutlet weak var messageTextView: UITextView!

    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labeCallTitle: UILabel!


    @IBOutlet weak var call1: UIButton!
    @IBOutlet weak var call2: UIButton!
 
    var isMessageTextEmpty = true

    //MARK: - ViewControllers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false

        setTextFieldData()
        
    }
    
    override func viewDidLayoutSubviews() {
 
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Actions
 
    @IBAction func sendMessage() {
        
        nameTextField.textColor = Validator.isValidTFName(nameTextField.text) ? .darkGray : .red
        emailTextField.textColor = Validator.isValidTFEmail(emailTextField.text) ? .darkGray : .red

        if let errorMessage = Validator.isValidMessage(messageTextView.text) {
            showAlert(errorMessage)
            return
        }
 
        if nameTextField.textColor  == .darkGray,  emailTextField.textColor  == .darkGray
        {
            messageTextView.resignFirstResponder()
            postMessage()
        }
    }
    
    // MARK: - Functions
    
    
    override func reloadTranslations() {
        
        title = TR("question_ask").uppercased()

        nameTextField.placeholder = TR("name")
        emailTextField.placeholder = TR("mail")
        messageTitleTextField.placeholder = TR("message_subject")
        messageTextView.text =  kEmpty

        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        btn.setImage(#imageLiteral(resourceName: "icons-send.pdf"), for: UIControl.State())
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(self.sendMessage), for: UIControl.Event.touchUpInside)
        
        let item = UIBarButtonItem(customView: btn)
        navigationItem.setRightBarButton(item, animated: false)
        //navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named : "icons-send"), style: .plain, target: self, action: #selector(sendMessage)), animated: false)
        
        labelDescription.text = TR("label_description_in_contact_us")

        labeCallTitle.text = TR("you_can_also_call")
        
        call1.setAttributedTitle(setCallAttributedString(supportPhoneNumber1, "call_1_description"), for: .normal)
        call2.setAttributedTitle(setCallAttributedString(supportPhoneNumber2, "call_2_description"), for: .normal)
 
        setMessageTextViewProperties()
    }
    
    func setCallAttributedString(_ numberStr: String, _ text : String) -> NSMutableAttributedString {
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .font :  UIFont.init(name: kFont_normal, size: 14)!,
            .foregroundColor: kColor_DarkGray
        ]
        
        
        let numberAttributes: [NSAttributedStringKey: Any] = [
            .font :  UIFont.init(name: kFont_normal, size: 14)!,
            .foregroundColor : kColor_Blue
        ]
        
        let textMain = NSMutableAttributedString(string: " - " + TR(text), attributes: textAttributes )
        let textNumber = NSMutableAttributedString(string: numberStr, attributes: numberAttributes )
        
        textNumber.append(textMain)
        
        return textNumber
    }
    
    func setTextFieldData(){
 
        if let logiInfo : LogInInfo = ModaManager.shared.getProfile() {
            self.emailTextField.text = logiInfo.data.email
            self.nameTextField.text = logiInfo.data.name
        }
        

    }
    
    override func textChanged(textField: UITextField) {
         
    }

    
    private func postMessage() {
        
        var parameters = [
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "message": messageTextView.text!
        ]
        
        if Validator.isValidMessage(messageTitleTextField.text) != nil {
            parameters.updateValue("subject", forKey: messageTitleTextField.text!)
        }
        
        addLightLoader()
        
        NetworkManager.shared.postMessage(parameters, errorFunction: showAlertFromNet) { line in
            
            self.removeBlurredLoader()
            self.showAlert(line)  
        }
        
    }

    //MARK: - TextField

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.textColor = .darkGray
        return true
    }


    //MARK: - TextViewDelegate

    
    
    func setMessageTextViewProperties(){
        
        if (messageTextView.text == nil) || (messageTextView.text == ""){
            isMessageTextEmpty = true
            messageTextView.textColor = UIColor.lightGray.withAlphaComponent(0.5)
            messageTextView.text  = TR("put_in_text") + " ... "
            return
        }
 
    }
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if isMessageTextEmpty  {
            textView.text = ""
        }
        textView.textColor = .darkGray
 
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (messageTextView.text.count > 0 ){
            isMessageTextEmpty = false
        } else {
            setMessageTextViewProperties()
        }
    }
    
    
}
