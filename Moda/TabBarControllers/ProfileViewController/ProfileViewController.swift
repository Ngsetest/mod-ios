//
//  ProfileViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/30/18.
//  Copyright © 2018 moda. All rights reserved.
//


import UIKit

class ProfileViewController: BaseViewController, UINavigationControllerDelegate  {
    
     @IBOutlet weak var subTitleLabel: UILabel!


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!

    @IBOutlet weak var tableView: TableProfileView!

    
    private var data: LogInInfo! {
        didSet {
            
            ModaManager.shared.setProfile(data)
            
            setTitleText()

            showWelcomeAlert()
            
        }
    }

    
    //MARK: - View Controllers

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addBlurredLoader(with: getBlurredHeight())

        if let token = editLocalToken() {
            profileDataRequest(token)
        }
        
        setTableSettings()
 
        navigationController?.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadTranslations()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

  
    //MARK: - Actions

    private func profileDataRequest(_ token: String) {
        
        NetworkManager.shared.getLogInInfo(token, errorFunction: { code, error in
            
            self.showAlertFromNet(code, error)

            _ = editLocalToken(kEmpty)
            
        }) {  model  in

            self.removeBlurredLoader()

            self.data = model
        }
     }
 
    
    
    @IBAction func goToSettings() {
        
        openSettingsApplication()
        
    }
    
   override  func askForLogout(){
        
        showAlert(TR("want_to_exit"), okLine: "yes", noLine: "no") {
            self.logOut()
        }
        
     }
    
    func logOut() {
        
        addLightLoader()
        
        NetworkManager.shared.postLogOutRequest(errorFunction: showAlertFromNet)
        { line in
            
            debugLog(#function + kSemicolons +  line)
            
            self.removeBlurredLoader()
            
            _ = editLocalToken(kEmpty)
            
            ModaManager.shared.setProfile(nil)
            
            self.setVC("GuestProfileViewController")
        }
        
    }
    
    
    //MARK: - Functions
    
    
    override func reloadTranslations() {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = TR("profile")
 
        subTitleLabel.text = TR("your_data").uppercased()
        
        tableView.reloadData()

     }
    
    func setTableSettings(){
        
        tableView.dataSource = tableView
        tableView.delegate = tableView
        tableView.parentVC = self
//        tableView.layer.borderWidth = 0.5
//        tableView.layer.borderColor = kColor_AppLightSilver.cgColor

    }
    func setTitleText(){
        
        name.text = "\(data.data.name) \(data.data.surname)"
        email.text = data.data.email
        phone.text = getFormattedPhoneNumber(data.data.phone)
        address.text = data.data.address
    }
    
    func showWelcomeAlert(){
        
        let welcomWas : Bool = getFromLocal("isWelcome") as? Bool ?? false
        
        if !welcomWas {
            showAlert(TR("welcome") + " \n\(data.data.name) !")
        }
        
        saveInLocal("isWelcome", true)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        item.tintColor = kColor_Black
        viewController.navigationItem.backBarButtonItem = item
    }
    
    
}
