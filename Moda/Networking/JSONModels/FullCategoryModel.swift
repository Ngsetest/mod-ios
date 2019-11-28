//
//  FullCategoryModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/6/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

struct FullCategoryModel: InitModel {
    let name: String
    let id: Int
    let parentId: Int
    let position: Int
    var children: [FullCategoryModel]
 
    mutating func orderChildren(){
        children.sort { (item1, item2) -> Bool in
             item1.name < item2.name
        }
    }
    
}
