//
//  PaymentModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/17/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation


//MyOrderModel

struct PaymentModel: InitModel {

    var orders: [Product]?
    var fullPrice: Int?
    
    var userId: Int = 0
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var subsrcribe: Bool?
    
    var address: String?
    var addressDescription : [String : String] = [:]
 
    var deliveryType: DeliveryType?
    
    var amountType: AmountType?
    
    var paymentType: PaymentType = .cod
    
    var dateFirst: Date?
    var dateSecond: Date?
    var dateLine: String?
    
    var cardNumber: String?
    var expire: String?
    var token: String?
     
    
    func createDictForJson() -> [String : Any]{
        
        
        var dictWithInfo = self.toDictionary()
        
        dictWithInfo.removeValue(forKey: "orders")
        dictWithInfo.removeValue(forKey: "dateLine")
        
        
        
        var newOrders = [String : [String : Any]]()

        for i in 0..<self.orders!.count {
            let z0 = self.orders![i]
            
            //TODO: --- This is for ALAMOFIRE LIBRARY only !
            // It happened that only this type of indexation is really works for Dictionary in Array for POST method in Alamofire:
            // to make the fake Dictionary from Array, Karl!
            //  https://stackoverflow.com/a/27831968/10908459
            
            newOrders["\(i)"] = (["id" :  z0.id,
                              "color" : ["id" : z0.color!.id, "name" : z0.color!.name],
                              "size" : ["id" : z0._size!.id, "name" : z0._size!.name],
                              "count" : z0.count ?? 1])
        } 
        
        dictWithInfo["orders"]  = newOrders 
        
//        debugLog("\(dictWithInfo)")
        return dictWithInfo
    }
}

struct Order: InitModel {
    let orderId: Int?
    let amount: Double?
    let status: Bool
    let data:MyOrderModel
}

struct Payment: InitModel {
    let message: String
    let status: Bool
}

struct JSONRpc: InitModel {
    let id: Int
    let jsonrpc: String
    let result: Result?
    let error: ErrorStruct?

    struct ErrorStruct: InitModel {
        let message: String
        let code: Int
    }
    struct Result: InitModel {
        let card: Card
    }
    
    struct Card: InitModel {
        let expire: String?
        let number: String?
        let recurrent: Bool?
        let token: String?
        let verify: Bool?
    }
}

struct JSONRpcVerifyCode: InitModel {
    let id: Int
    let jsonrpc: String
    let result: Result
    
    struct Result: InitModel {
        let sent: Bool?
        let phone: String?
        let wait: Int?
    }
}

