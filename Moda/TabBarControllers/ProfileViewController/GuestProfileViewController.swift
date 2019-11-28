//
//  GuestProfileViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/30/18.
//  Copyright © 2018 moda. All rights reserved.
//


import SkyFloatingLabelTextField
import UIKit

class GuestProfileViewController: BaseViewController {
    
    @IBOutlet weak var titleRegLebel: UILabel!

    
    @IBOutlet weak var textLabel: UILabel!
 
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
             self.loginButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var registrationButton: UIButton!{
        didSet {
            self.registrationButton.clipsToBounds = true
        }
    }

    @IBOutlet weak var tableView: TableProfileView!{
        didSet{
            self.tableView.namesOfCell.removeLast()
        }
    }
 
  
    //MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableSettings()
 
        if let _ = editLocalToken() {
            if let _ = ModaManager.shared.getProfile() {
                openProfileVC()
            }
        }
        
        ModaManager.shared.getDiscountInfo()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
        
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
     }
 
    // MARK: - Actions
    
    @IBAction func goToSettings() {
        
        openSettingsApplication()
        
    }
  
    @IBAction func signIn(_ sender: UIButton) { 
        
        showVCFromName("RegisterViewController") 
     }
    
    func openProfileVC(){
        
        setVC("ProfileViewController")
        
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        showVCFromName("LoginViewController")
    }
    
    // MARK: - Functions
    
    
    override func reloadTranslations() {
        
        
        navigationItem.title = TR("profile")
        

        titleRegLebel.text = TR("bonus_title")
        textLabel.text = TR("bonus_title_text")
    
        loginButton.setTitle(TR("do_login"), for: .normal)
        registrationButton.setTitle(TR("do_registration"), for: .normal)
        
        tableView.reloadData()
        
    }
    
    func setTableSettings(){
        
        tableView.dataSource = tableView
        tableView.delegate = tableView
        tableView.parentVC = self
        
    }
    
}
