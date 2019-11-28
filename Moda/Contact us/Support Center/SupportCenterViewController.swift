//
//  SupportCenterViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/12/18.
//  Copyright © 2018 moda. All rights reserved.
//
import UIKit
class SupportCenterViewController: BaseViewController {
 
    @IBOutlet weak var tableView: UITableView!
    
    private let imageArry: [UIImage] = [#imageLiteral(resourceName: "whereIsIcon"), #imageLiteral(resourceName: "supportTimeIcon"), #imageLiteral(resourceName: "chooseCorrectSize")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = .none

        self.registerTableViewCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        reloadTranslations()
        
    }
    
    func registerTableViewCell(){
        tableView.register(UINib(nibName: ImageSupportTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ImageSupportTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: TitleSupportTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TitleSupportTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ButtonSupportTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonSupportTableViewCell.reuseIdentifier)
    }
    
    override func reloadTranslations() {
        title = TR("support_service").uppercased()
        tableView.reloadData()
    }
}
extension SupportCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            showVCFromName(kProfileCellControllers[1])
            return
        }
 
        var linkString = kEmpty
        var titleString = kEmpty
        
        let ind = indexPath.row

        switch indexPath.section {
        case 0:
            
            linkString = upperSupportLinks[ind]
            titleString = upperSupportTitle[ind]
            break
            
        case 1:
            
            linkString = middleSupportLinks[ind]
            titleString = middleSupportLabels[ind]
            break
            
        default:
            break
        }
        
        openWebPageFrom(NetworkManager.baseURL + linkString, titleString)
 
    }
}
extension SupportCenterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return upperSupportTitle.count
        case 1:
            return middleSupportLabels.count
        default:
            return 0//1
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageSupportTableViewCell.reuseIdentifier, for: indexPath) as! ImageSupportTableViewCell
            cell.selectionStyle = .none
            cell.supportImage.image = imageArry[indexPath.item]
            cell.supportTitle.text = TR(upperSupportTitle[indexPath.item])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleSupportTableViewCell.reuseIdentifier, for: indexPath) as! TitleSupportTableViewCell
            cell.selectionStyle = .none
            cell.supportTitle.text = TR(middleSupportLabels[indexPath.item])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonSupportTableViewCell.reuseIdentifier, for: indexPath) as! ButtonSupportTableViewCell
           // cell.supportTitle.text = supportLabels[indexPath.item]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 47
        default:
            return 60
        }
    }
}
