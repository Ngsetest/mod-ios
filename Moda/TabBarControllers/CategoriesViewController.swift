//
//  CategoriesViewController.swift
//  Moda
//
//  Created by admin_user on 5/21/19.
//  Copyright © 2019 moda. All rights reserved.
//

import UIKit

class CategoriesViewController: SearchViewController {
    
    let cellNameCategory = CategorieTableViewCell.identifier
    let cellNameSearch = HeaderCollectionProductsTableViewCell.identifier
    @IBOutlet weak var coverImageView: UIImageView!{
        didSet{
            self.coverImageView.isHidden = true
        }
    }
    
    
    // MARK: - Data
    
    var data: [FullCategoryModel]?
    
    var genderSpecificData: [FullCategoryModel]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
     // MARK: - Flags
 
    var isNext = false
    var isSearch = false
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!

 
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

        if genderSpecificData == nil {
            
            addBlurredLoader(with: getBlurredHeight())
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.categoriesRequest()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !isNext && (genderSelection.selectedSegmentIndex != ModaManager.shared.selectedGender){
            genderSelection.selectedSegmentIndex = ModaManager.shared.selectedGender
            genderSelectionValueChanged()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        reloadSearchLineAndTable()
  
        if isNext {
            searchBar.isHidden = true
            genderSelection.isHidden = true
            genderSelectionButton.isHidden = true
            tableViewTop.constant = -(searchBar.frame.height + 50)
            view.layoutIfNeeded()
        }
        
    }
    
    
    // MARK: -
    
    override func genderSelectionValueChanged() {
 
        super.genderSelectionValueChanged()
        
        if let gData = data?[ModaManager.shared.selectedGender].children {
            
            genderSpecificData = gData
            
            UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
            
            tableView.reloadTableWithAnimation()
        }
        
    }
 
   override  func registerTableViewCells() {
        
        super.registerTableViewCells()
        
        tableView.register(UINib(nibName: cellNameCategory, bundle: nil),
                           forCellReuseIdentifier:cellNameCategory)
        
        tableView.register(UINib(nibName: cellNameSearch, bundle: nil),
                           forCellReuseIdentifier:cellNameSearch)
    }
 
    func categoriesRequest() {
        
        NetworkManager.shared.getCategories(errorFunction: showAlertFromNet, answerFunction: answerFuncOnGetCategories)
    }
    
    override func settitleName(){
        navigationItem.title = TR("catalog")
        
    }
    
    
    func answerFuncOnGetCategories(_ model : [FullCategoryModel]){
        
        data = model
        
//        for i in 0..<data!.count{
//            data![i].orderChildren()
//        }
        
        if !isNext {
            genderSpecificData = data![genderSelection.selectedSegmentIndex].children
        }
        
        removeBlurredLoader()
        
    }
    
    
    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return super.numberOfSections(in: tableView)
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        return genderSpecificData?.count ?? 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearch {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellNameCategory) ??
            UITableViewCell(style: .default, reuseIdentifier: cellNameCategory)) as! CategorieTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text =  genderSpecificData![indexPath.row].name.capitalizingFirstLetter()
        cell.titleLabel.font = UIFont(name: kFont_medium, size: 15)!
        cell.titleLabel.textAlignment = .left
        cell.titleLabel.numberOfLines = 1
        let arrow = UIImageView(image: UIImage(named: "right-chevron"))
        cell.accessoryView = arrow
        cell.tintColor = UIColor.black
        cell.arrow.isHidden = true
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearch {
            return super.tableView(tableView, didSelectRowAt: indexPath)
        }
        
        
        if genderSpecificData![indexPath.row].children.count != 0 {
            let nextVC = getVCFromMain("CategoriesViewController") as! CategoriesViewController
            nextVC.isNext = true
            nextVC.genderSpecificData = genderSpecificData![indexPath.row].children
            nextVC.data = nextVC.genderSpecificData
            nextVC.navigationItem.title = genderSpecificData![indexPath.row].name.uppercased()
            showVC(nextVC)
        } else {
            let nextVC = getVCFromMain("ProductListViewController") as! ProductListViewController
            nextVC.id = genderSpecificData![indexPath.row].id
            nextVC.textForTitle = genderSpecificData![indexPath.row].name
            nextVC.reloadListTags( [nextVC.textForTitle])
            showVC(nextVC)
        }
    }
    
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSearch {
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if isSearch {
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
        
        return 0
    }

    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        isSearch = !searchText.isEmpty
        super.searchBar(searchBar, textDidChange: searchText)
 
    }
}

