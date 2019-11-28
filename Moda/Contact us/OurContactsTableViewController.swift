//
//  OurContactsTableViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 6/1/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class OurContactsTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadTranslations()
    }
    
    override func reloadTranslations() {
      
        title = TR("our_contacts").uppercased()
        tableView.reloadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0 : return 1
        case 1 : return 3
        default : return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_phone", for: indexPath)
            cell.layoutIfNeeded()
            
            switch indexPath.row {
            case 0 :
                cell.textLabel?.text = TR("to_call") + " " + supportPhoneNumber
                cell.detailTextLabel?.text = TR("call_time")
            default : break
            }
            
            return cell
            
        } else {
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_social", for: indexPath)
            cell.layoutIfNeeded()

            var model = getSocialModelFrom(.web)
            
            switch indexPath.row {
             case 0 :  model = getSocialModelFrom(.facebook)
             case 1 :  model = getSocialModelFrom(.instagram)
             case 2 :  model = getSocialModelFrom(.telegram)
            default : break
            }
            
            cell.imageView?.image = UIImage(named: "link_img_" + model.name)
            cell.textLabel?.text = model.name.capitalizingFirstLetter()
            cell.detailTextLabel?.text = "@" + model.name_link
 
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0: callPhone(supportPhoneNumberDial)
            default: break
            }
        case 1 :
            switch indexPath.row {
            case 0 :  openSocialPage(.facebook)
            case 1 :  openSocialPage(.instagram)
            case 2 :  openSocialPage(.telegram)
            default : break
            }
 
        default: break
        }
    }
}
