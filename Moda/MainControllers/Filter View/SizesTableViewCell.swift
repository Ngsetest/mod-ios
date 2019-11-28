//
//  SizesTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/19/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import UIKit

class SizesTableViewCell:  BaseFilterTableViewControllerCell {
    
    
    var data: [Size]? 
    //MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
 
    //MARK: - override all
    
    
    override func setNamesProperties(){
        
        tableeOffset = 1
        contentOffset = 170.0
        
        nameOfCellIdentificator = SizesTableViewCell.identifier
        nameOfCellSector = "size"
        nameTitleKey = "sizes"
        
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
