//
//  BrandsTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/20/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import UIKit

class BrandsTableViewCell: BaseFilterTableViewControllerCell {
    
    var data: [Brand]? 
    
    //MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    //MARK: - override all
    
    
    override func setNamesProperties(){
        
        tableeOffset = 100
        contentOffset = 65.0
        
        nameOfCellIdentificator = BrandsTableViewCell.identifier
        nameOfCellSector = "brand"
        nameTitleKey = "brands"
        
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
