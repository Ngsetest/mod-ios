//
//  CardPayModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/21/18.
//  Copyright © 2018 ason. All rights reserved.
//

import Foundation

struct Card: Codable {
    let expire: String
    let number: String
    let recurrent: Bool
    let token: String
    let verify: Bool
}

struct Result: Codable { let card: Card }

struct CardCreatePay: Codable {
    let id: Int
    let result: Result
}

struct CardGetVerifyCode: Codable {
    let id: Int
    let result: Result

    struct Result: Codable {
        let sent: Bool
        let phone: String
        let wait: Int
    }
}

struct CardVerify: Codable {
    let id: Int
    let result: Result
}

