//
//  CategorieTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/26/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class CategorieTableViewCell: BaseFilterTableViewControllerCell {
    
    
    var data: [Category]?
    
    //MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

 
    
    //MARK: - override all
 
    
    override func setNamesProperties(){
        
        tableeOffset = 50
        contentOffset = 0.0

        nameOfCellIdentificator = CategorieTableViewCell.identifier
        nameOfCellSector = "category"
        nameTitleKey = "categories"
        
    }
    
    override func getItemName(_ index : IndexPath) -> String {
        return data?[index.row].name ?? kEmpty
    }
    
    
    override func getItemId(_ index : IndexPath) -> Int{
        return data?[index.row].id ?? 0
    }
    
    
    override func getItemsCount(_ section : Int) -> Int{
        return  data?.count ?? 0
    }

    
}
