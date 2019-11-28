//
//  FilterViewController.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/2/18.
//  Copyright © 2018 moda. All rights reserved.
//


import UIKit

enum FilterTypes {
    case category
    case brand
    case size
    case color
    case price
}

class FilterViewController: BaseViewController {
    var tempCloseFlag : Bool = false

    // MARK: - Data
    var orderOfFilters = [FilterTypes]()
    
    var tags = [String : [String]]()

    var filterParams = [String : Any]()

    var data: AttributesModel? { didSet { tableView.reloadData() } }
    
    var collection: Collection? {
        didSet {
            setFilterButton()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var result: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Controller

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setFiltersOrder()
        
        result.isEnabled = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tabBarController?.navigationItem.backBarButtonItem?.title = kEmpty
        registerTableViewCells(tableView)
        
        
        addBlurredLoader(with: getBlurredHeight())
        DispatchQueue.global(qos: .userInitiated).async { self.requestAttributes() }
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTranslations()
        tableView.reloadData()
    }
    
    // MARK: - Action

    @IBAction func goToResults(_ sender: UIButton) {
        guard data != nil else { return }
        
        for i in 0..<orderOfFilters.count{
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? BaseFilterViewControllerCell {
                setNewDataFromCell(cell, false)
            }
        }

        requestCollection(true)
 
    }
    
    
    func  openProductListView(){

        let arrTags = setNewTagsArray()

        navigationController!.viewControllers.forEach {
            if let vc = $0 as? ProductListViewController {
                vc.data = collection
                vc.filterParams = filterParams
                vc.reloadListTags(arrTags)
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    func setNewTagsArray() -> [String] {
        var tags_arr = [String]()
        
        tags.forEach {
            tags_arr.append(contentsOf: $0.value)
        }
        
        return tags_arr
    }
    
    func setFiltersOrder(){
        
        orderOfFilters  = tempCloseFlag
            ? [.category , .price , .size, .color ]
            : [.category , .brand, .price , .size, .color ]
    }
    
    func setFilterButton(){

        let total = collection?.total != nil ? "\(collection!.total!)" : kEmpty

        result.setTitle(TR("show_results") +  " " +  total, for: .normal)

        result.isEnabled = (collection?.total ?? 0 ) > 0

        
    }
    
    override func reloadTranslations() {
        
        title = TR("filter").uppercased()

        setFilterButton()
        
        tableView.reloadData()
        
    }
    
    private func registerTableViewCells(_ tableView: UITableView) {
        tableView.register(
            UINib(nibName: SizesTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SizesTableViewCell.identifier
        )
        tableView.register(
            UINib(nibName: BrandsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: BrandsTableViewCell.identifier
        )
        tableView.register(
            UINib(nibName: PriceRangeTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PriceRangeTableViewCell.identifier
        )
        tableView.register(
            UINib(nibName: ColorsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ColorsTableViewCell.identifier
        )
        tableView.register(
            UINib(nibName: CategorieTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: CategorieTableViewCell.identifier
        )
    }
    
    private func requestAttributes() {
        
        NetworkManager.shared.getAttributes(errorFunction: showAlertFromNet) { model in
            self.data = model
            self.requestCollection()
        }
    }
    
    private func requestCollection(_ withViewExit : Bool = false) {

        
        
        filterParams = filterParams.filter({ key, value  -> Bool in
 
            if let arrValue = value as? [Int] {
                return arrValue.count > 0
            }
            
            return true
        })
        
        NetworkManager.shared.getFiltersResults(filterParams, errorFunction: { code, error in
            self.collection = nil
            self.showAlertFromNet(code,error)
        }){ model in
            self.collection = model
            self.setFilterButton()
            self.removeBlurredLoader()
            
            if withViewExit && ( model.data.count > 0) {
                self.openProductListView()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard data != nil else { return 0 }

        return orderOfFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch orderOfFilters[indexPath.row] {
        case .category:
            let cell = tableView.dequeueReusableCell( withIdentifier: CategorieTableViewCell.identifier,
                                                      for: indexPath ) as! CategorieTableViewCell
            cell.data = data!.category
            cell.setDataFromTag(filterParams)
 
            return cell
        case .brand:
            let cell = tableView.dequeueReusableCell( withIdentifier: BrandsTableViewCell.identifier,
                                                      for: indexPath ) as! BrandsTableViewCell
            cell.data = data!.brand
            cell.setDataFromTag(filterParams)
            return cell
        case .price:
            let cell = tableView.dequeueReusableCell( withIdentifier: PriceRangeTableViewCell.identifier,
                                                      for: indexPath ) as! PriceRangeTableViewCell
            cell.setMaxMinValues(priceFromTo[0],priceFromTo[1])
            cell.setDataFromTag(filterParams)
            return cell
        case .size:
            let cell = tableView.dequeueReusableCell( withIdentifier: SizesTableViewCell.identifier,
                                                      for: indexPath ) as! SizesTableViewCell
            cell.data = data!.size
            cell.setDataFromTag(filterParams)
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell( withIdentifier: ColorsTableViewCell.identifier,
                                                      for: indexPath ) as! ColorsTableViewCell
            cell.data = data!.color
            cell.setDataFromTag(filterParams)
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! BaseFilterViewControllerCell
        if !cell.hideOn {
            setNewDataFromCell(cell, true)
        } else {
            cell.openAll(tableView)
        }
        
        cell.hideOn = !cell.hideOn

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func setNewDataFromCell(_ cell : BaseFilterViewControllerCell,_ animateCloseAction : Bool) {
    
        let newData = cell.hideAll(tableView, animateCloseAction)
        filterParams[newData.0] = newData.1
        tags[newData.0] = newData.2
        if animateCloseAction{
            requestCollection()
        }
    }
}
