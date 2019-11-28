//
//  NotificationViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/7/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {
 
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!

    @IBOutlet weak var buttonOn: UIButton!
    @IBOutlet weak var buttonLater: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonOn.layer.cornerRadius = 4
        buttonLater.layer.cornerRadius =  buttonLater.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
    }
    
    
    override func reloadTranslations() {
 
        titleText.text = TR("notif_turn_on_text")
        
        text1.text = TR("tutorial_text_1")
        text2.text = TR("tutorial_text_2")
        text3.text = TR("tutorial_text_3")

        buttonOn.setTitle(TR("continue"), for: .normal)
 
    }
    
    @IBAction func handleTurnOnNotification(_ sender: Any) {

        registerNotifications()
        
        startMainApp()

    }
    
    
    @IBAction func handleLatter(_ sender: Any) {

        startMainApp()

        
    }
    
    func startMainApp(){
        ModaManager.shared.setModaNotificationReminer("token")

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        viewController?.view.frame = rootViewController.view.frame
        viewController?.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: { completed in
            // maybe do something here
        })
    }
}
