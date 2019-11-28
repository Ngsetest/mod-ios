//
//  CountryChooseViewController.swift
//  Moda
//
//  Created by admin_user on 8/17/19.
//  Copyright © 2019 mod. All rights reserved.
//

import UIKit

class CountryChooseViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var completionHandler: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTranslations()
    }
    
    
    override func reloadTranslations() {
        
        titleLabel.text = TR("title_country")
        
    }
}

extension CountryChooseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModaManager.shared.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id_country", for: indexPath)
        cell.layoutIfNeeded()
        
        let item = ModaManager.shared.countries[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.code == ModaManager.shared.country ? .checkmark : .none
        cell.imageView?.image = nil

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ModaManager.shared.country =  ModaManager.shared.countries[indexPath.row].code!
        navigationController?.popViewController(animated: true)
        
    }
}
