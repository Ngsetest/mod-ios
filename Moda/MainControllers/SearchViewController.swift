//
//  SearchViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/2/18.
//  Copyright © 2018 moda. All rights reserved.
//


import UIKit


class SearchViewController: BaseViewController {

    // MARK: - Data

    var lineForCheck = kEmpty

    var searchResult: SearchModel! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var genderSelectionButtonConstraints = [NSLayoutConstraint]()
    let genderSelectionButton = UIButton()
 

    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        setGenderSelectionProperties()
 
        registerTableViewCells()

        searchBar.changeSearchBarColor(fieldColor: .white, backColor: .white, borderColor: .white)
        searchBar.setMagnifyingGlassColorTo(color: .black)
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = .white
        tableView.contentInset.top = -36
        reloadTranslations()
        
        searchBar.removeBorder()
        searchBar.addBottomBorder(.black, borderWidth: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Actions

    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Selectors

    
    @objc func genderSelectionValueChanged() {

        cleanSearch()
        
        ModaManager.shared.selectedGender = genderSelection.selectedSegmentIndex

        UIView.animate(withDuration: 0.3) {
            self.genderSelectionButton.frame.origin.x =
                8 + self.genderSelectionButton.frame.width * CGFloat(self.genderSelection.selectedSegmentIndex)
        }
    }

    // MARK: - Private methods
 
    func registerTableViewCells() {

        tableView.register(
            UINib(nibName: HeaderCollectionProductsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: HeaderCollectionProductsTableViewCell.identifier
        )
        
        
    }
    
    func setGenderSelectionProperties(){
        
        view.customize(
            segmentedControl: genderSelection,
            with: genderSelectionButton,
            and: &genderSelectionButtonConstraints
        )
        
        genderSelection.selectedSegmentIndex = ModaManager.shared.selectedGender
        genderSelection.addTarget(self, action: #selector(genderSelectionValueChanged), for: .valueChanged)
        
    }
    
    
    override func reloadTranslations() {
        
        settitleName()
        setNamesForGenderSelection(genderSelection)
        searchBar.placeholder = "   " + TR("search_placeholder")

    }

    private func searchRequest(_ query: String, with gender: Int) {
        
        NetworkManager.shared.getSearchResults(query, gender, errorFunction: showAlertFromNet) { model in
            
            self.searchResult = model
            
            self.reloadSearchLineAndTable()

        }
        
    }
    
    func settitleName(){
        navigationItem.title = TR("search")

    }
    func cleanSearch(){
        
        searchBar.text = nil
        searchBar.endEditing(true)
        reloadSearchLineAndTable()
    }
    
    func reloadSearchLineAndTable(){
        
        hideLineOfTabBar(false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        settitleName()
        
        lineForCheck = searchBar.text?.lowercased() ?? kEmpty
        
        if lineForCheck == kEmpty {
            searchResult = nil
        }
        
        tableView.reloadData()
    }
    
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard searchResult != nil else { return 0 }

        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchResult != nil else { return 0 }

        var rowsCount = 0
        switch section {
        case 0:
            rowsCount = searchResult.brand.count
        case 1:
            rowsCount = searchResult.category.count
        case 2:
            rowsCount = searchResult.product.count
        default:
            break
        }

        return rowsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell_id_SearchItemTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            UITableViewCell(style: .default, reuseIdentifier: identifier)

        var text = kEmpty
        switch indexPath.section {
        case 0:
            text = searchResult.brand[indexPath.row].name
        case 1:
            text = searchResult.category[indexPath.row].name
        case 2:
            text = searchResult.product[indexPath.row].brand.name + " " + searchResult.product[indexPath.row].name
        default:
            break
        }

        cell.textLabel?.numberOfLines = 1
        cell.selectionStyle = .none

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attrStr = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont(name: kFont_normal, size: 15)!,
                .foregroundColor: kColor_Gray,
                .paragraphStyle: paragraphStyle,
            ]
        )
        
        let str = NSString(string: text.lowercased())
        let range = str.range(of: searchBar.text!.lowercased())
        
        attrStr.addAttributes(
            [NSAttributedStringKey.foregroundColor: kColor_Black],
            range: range
        )
        
        cell.textLabel?.attributedText = attrStr
        cell.textLabel?.textAlignment = .left


        return cell
    }
    
    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = getVCFromMain("ProductListViewController") as! ProductListViewController
        _ = nextVC.view
        
        switch indexPath.section {
        case 0:
            nextVC.isBrand = true
            nextVC.id = searchResult.brand[indexPath.row].id
            nextVC.textForTitle = searchResult.brand[indexPath.row].name.uppercased()
            nextVC.reloadListTags([nextVC.textForTitle ])
            showVC(nextVC)
            
        case 1:
            nextVC.id = searchResult.category[indexPath.row].id
            nextVC.textForTitle = searchResult.category[indexPath.row].name.uppercased()
            nextVC.reloadListTags([nextVC.textForTitle ])
            showVC(nextVC)
            
        case 2:
                        
            let productVC = getVCFromMain("ProductViewController") as! ProductViewController
            productVC.productShortData = searchResult.product[indexPath.row].getShortProduct()
            showVC(productVC)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(
            withIdentifier: HeaderCollectionProductsTableViewCell.identifier
        ) as! HeaderCollectionProductsTableViewCell

 
        header.headerTitle.text = TR(searchSections[section]) + " (\(tableView.numberOfRows(inSection: section)))"
        header.backgroundColor = kColor_White
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    //MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchRequest(searchText, with: genderSelection.selectedSegmentIndex + 1)
        } else {
            cleanSearch()
        }
    }
    

}

