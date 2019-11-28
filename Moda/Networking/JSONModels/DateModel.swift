//
//  DateModel.swift
//  Moda
//
//  Created by Alimov Islom on 7/5/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

struct DateMethodsModel: InitModel {

    let status : Bool
    let price : Int
    let date : String
}

struct DateModel: InitModel {
    let message: String
    let methods : [String : DateMethodsModel]
    let status: Bool
}
