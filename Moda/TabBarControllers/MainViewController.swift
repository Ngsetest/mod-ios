//
//  FirstViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/23/18.
//  Copyright © 2018 moda. All rights reserved.
//

import ImageSlideshow
import UIKit


class MainViewController: BaseViewController, UISearchBarDelegate {

    var data:    MainModel? {  didSet { setNewDataChanges() } }
    var profile: LogInInfo? {  didSet { ModaManager.shared.setProfile(profile) }  }
    
    private var genderSelectionButtonConstraints = [NSLayoutConstraint]()
    private let genderSelectionButton = UIButton()

    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var coverImageView: UIImageView!{
        didSet{
            self.coverImageView.isHidden = true
        }
    }
    private let noContentView = NoContentView()

    // MARK: - View Controllers
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        initViewStuff()
        
        setGenderProperties()
        
        doStuffWithDispatchQueue()
        
        addBlurredLoader()
        
        searchBar.changeSearchBarColor(fieldColor: .white, backColor: .white, borderColor: .white)
        searchBar.setMagnifyingGlassColorTo(color: .black)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.init(name: kFont_medium, size: 16)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.init(name: kFont_medium, size: 16)
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        tableView.contentInset.top = -26
        reloadTranslations()
        
        searchBar.removeBorder()
        searchBar.addBottomBorder(.black, borderWidth: 1)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        loadGenderData()
        
    }
    
    
    // MARK: - Private methods
    
    
    func localPreInitClosure(_ vc : inout UIViewController) {
        
        navigationController?.navigationBar.tintColor = kColor_Black
        navigationItem.title = kEmpty
        navigationController?.isNavigationBarHidden = false
        
    }
    
    private func initViewStuff(){
        
        tabBarController?.tabBar.clipsToBounds = true
        navigationItem.title = kEmpty
        
        setTableProperties()
        
        if let token = editLocalToken() {
            profileDataRequest(token)
        }
    }
    
    override func reloadTranslations() {

        searchBar.placeholder = "    " + TR("search_placeholder")
        setNamesForGenderSelection(genderSelection)

    }
    
    
    func setTableProperties(){
        
        registerTableViewCells(tableView)
        tableView.allowsSelection = true

    }
    
    func setNewDataChanges(){
        
        tableView.reloadData()
    }
    
    func setGenderProperties(){
        
        view.customize(segmentedControl: genderSelection,
                       with: genderSelectionButton,
                       and: &genderSelectionButtonConstraints)
        
        genderSelection.addTarget(self, action: #selector(genderSelectionValueChanged), for: .valueChanged)

    }

    
    func doStuffWithDispatchQueue(){
        
        editFavoriteList(answerFunction: nil)
        
        editBagList(answerFunction: nil)
        
    }
    
    private func loadGenderData(){
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.updateListForMainView(indexesOfTopMenuChoose[0])
            
        }
        
        let currentG = ModaManager.shared.selectedGender
        
        removeBlurredLoader()
        
//        if (data == nil) ||
//            ( (data != nil) && (genderSelection.selectedSegmentIndex != currentG) ) {
//             
//            coverImageView.isHidden = false
//        } else {
//            coverImageView.isHidden = true
//
//            tableView.reloadData()
//        }
//    
    }
    
    
    private func registerTableViewCells(_ tableView: UITableView) {
        tableView.register(UINib(nibName: SliderTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SliderTableViewCell.identifier)
        tableView.register(UINib(nibName: SliderTableHorizontalCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SliderTableHorizontalCell.identifier)
        tableView.register(UINib(nibName: HeaderCollectionProductsTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: HeaderCollectionProductsTableViewCell.identifier)
        
        tableView.register(UINib(nibName: CollectionProductsTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: CollectionProductsTableViewCell.identifier)
        
        tableView.register(UINib(nibName: CollectionCatalogueTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: CollectionCatalogueTableViewCell.identifier)

    }
    
    // MARK: - NETWORK
    
    private func profileDataRequest(_ token: String) {
        
        NetworkManager.shared.getLogInInfo(token, errorFunction: { code, error in
            
            debugLog(#function + kSemicolons +  error)
           
            _ = editLocalToken(kEmpty)

        }) {   model  in
            
            self.profile = model

        }
        
    }
 
    private func updateListForMainView(_ gender: Int) {
        
        NetworkManager.shared.getMainViewModel(gender, errorFunction: showAlertFromNet,
                                                     answerFunction: onAnswerProductList)
        
    }
    
    
    func onAnswerProductList(_ model : MainModel){
        
        data = model 
        
        for item in model.productsData {
            if item.value.data.count == 0 {
                data!.productsData.removeValue(forKey: item.key)
            }
        }
        
        genderSelection.selectedSegmentIndex = ModaManager.shared.selectedGender
 
        switchGenders()
        
        coverImageView.isHidden = true

        removeBlurredLoader()
    }
    
    // MARK: - Search
     
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       
        showVCFromName("SearchViewController", funcPreInit: localPreInitClosure)

        return false
    } 
    
    // MARK: - Selectors

    @objc private func genderSelectionValueChanged(_ sender: UISegmentedControl) {
        
        
        let tmp = sender.selectedSegmentIndex
        
        sender.selectedSegmentIndex = ModaManager.shared.selectedGender
        ModaManager.shared.selectedGender = tmp
        
        if tmp == 2 || tmp == 3 {
            noContentView.frame = tableView.frame
            tableView.isHidden = true
            genderSelection.selectedSegmentIndex = ModaManager.shared.selectedGender
            
            switchGenders()
            
            coverImageView.isHidden = true
            searchBar.isHidden = true
            self.view.addSubview(noContentView)
            
            return
        }
        
        searchBar.isHidden = false
        tableView.isHidden = false
        noContentView.removeFromSuperview()
        
        addBlurredLoader(with: getBlurredHeight())

        DispatchQueue.global(qos: .userInitiated).async {
            
            self.updateListForMainView(indexesOfTopMenuChoose[tmp])
            
        }
        
    }
    
    func switchGenders(){
        
        NSLayoutConstraint.deactivate(genderSelectionButtonConstraints)
        genderSelectionButtonConstraints = [
            genderSelectionButton.topAnchor.constraint(equalTo: genderSelection.bottomAnchor),
            genderSelectionButton.heightAnchor.constraint(equalToConstant: 1),
            genderSelectionButton.leftAnchor.constraint(
                equalTo: genderSelection.leftAnchor,
                constant: genderSelectionButton.frame.width * CGFloat(self.genderSelection.selectedSegmentIndex)
            ),
            genderSelectionButton.widthAnchor.constraint(
                equalTo: genderSelection.widthAnchor,
                multiplier: 1 / CGFloat(genderSelection.numberOfSegments)
            ),
        ]
        NSLayoutConstraint.activate(genderSelectionButtonConstraints)
    }

    
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.blocks.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        guard  let item = data?.blocks[indexPath.row] else { return UITableViewCell()}
       
        switch item {
        case .banners(let items, let  name):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableHorizontalCell.identifier,
                                                     for: indexPath) as! SliderTableHorizontalCell
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            
            cell.data = items
            cell.name.text = name
            cell.name.isHidden = indexPath.row == 0

            return cell
            
        case .sliders(let items, let  name):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCatalogueTableViewCell.identifier,
                                                     for: indexPath) as! CollectionCatalogueTableViewCell
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            
            cell.labelTitle.text = name
            cell.data = items
            
            return cell

        case .collection(let collection, let name):

            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionProductsTableViewCell.identifier,
                                                     for: indexPath) as! CollectionProductsTableViewCell
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
 
            cell.data = collection
            cell.title.text = name
            
            return cell
        }
        
    }
    
}

//  MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        guard  let item = data?.blocks[indexPath.row] else { return 0}
        
        switch item {
        case .banners:  return 300
        case .sliders:  return 310
        case .collection:  return 360
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        guard  let item = data?.blocks[indexPath.row] else { return }
        
        switch item {
            
        case .collection(let collection, let name):
            
            let productListVC = getVCFromMain("ProductListViewController") as! ProductListViewController
            
            productListVC.id = collection.data.first?.category.id
            productListVC.textForTitle = name.uppercased()
            
            changeVCInTabBarController(productListVC)
            
            return
            
        default:
            return
        }
    }
 
}
