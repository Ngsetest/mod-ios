//
//  ProfileEmbededTableViewController.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 25.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit


class TableProfileView: UITableView,  UITableViewDelegate , UITableViewDataSource {

    weak var parentVC : UIViewController?

    var namesOfCell =  [kProfileCellName, kSupportCellName, kSupportCellName2, ["logout"]]
    var viewsIdOfCell =  [kProfileCellControllers, kSupportCellControllers, kSupportCellControllers2,  [kEmpty]]
 
    //MARK: - Tableview
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return namesOfCell.count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return namesOfCell[section].count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_profile", for: indexPath)
        cell.layoutIfNeeded()
        
        let nameCode = namesOfCell[indexPath.section][indexPath.row]
        cell.textLabel?.text = TR(nameCode)
        cell.imageView?.image = nil
        
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named : nameCode)
            if indexPath.row == 0 {
                cell.textLabel?.text = ModaManager.shared.countries.filter{ $0.code == ModaManager.shared.country}.first?.name
            }
        }
        
        let idname = viewsIdOfCell[indexPath.section][indexPath.row]
 
        if idname == kEmpty{
            cell.textLabel?.textColor = kColor_Red
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = kColor_Black
            cell.accessoryType = .disclosureIndicator
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let idname = viewsIdOfCell[indexPath.section][indexPath.row]
        
        if idname == kEmpty{
            parentVC?.askForLogout()
        } else {
            parentVC?.showVCFromName(idname)
        }
    }

}

