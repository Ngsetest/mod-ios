//
//  AuthFullModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/9/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation
 

struct ImageCartn: InitModel {
    let url: String
}

struct LogIn: InitModel {
    let token: String
    let expired: Int
    let tokenType: String
}

struct LogInInfo: InitModel {
    let status: String
    let data: UserData
}

struct ErrorsCheck: InitModel {
    let id: String?
    let name: String?
    let surname: String?
    let email: String?
    let address: String?
    let phone: String?
    
}

struct UserData: InitModel {
    let id: Int
    let name: String
    let surname: String
    let email: String
    let address: String
    let phone: String
    
}

struct AccAlive: InitModel {
    let status: String
    let message: String
}
