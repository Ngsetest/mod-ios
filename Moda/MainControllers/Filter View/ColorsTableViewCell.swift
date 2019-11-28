//
//  ColorsTableViewCell.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/20/18.
//  Copyright © 2018 Ruslan Lutfullin. All rights reserved.
//

import UIKit

class ColorsTableViewCell:  BaseFilterTableViewControllerCell {
    
    
    var data: [Color]?
    
    //MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK: - override all
    
    
    override func setNamesProperties(){

        tableeOffset = 51
        contentOffset = 220.5
        
        table.register(UINib(nibName: ItemColorTableViewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ItemColorTableViewCell.identifier)
        
        nameOfCellSector = "color"
        nameTitleKey = "colors"
        
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
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemColorTableViewCell.identifier,
                                                 for: indexPath) as! ItemColorTableViewCell
        cell.selectionStyle = .none

        cell.color?.backgroundColor = data![indexPath.row].value.hexColor
        cell.label?.text = getItemName(indexPath).uppercased()
        cell.label.font = UIFont(name: kFont_normal, size: 12)!
        
        checkCellWithV(cell, indexPath)

        return cell
    }
}

