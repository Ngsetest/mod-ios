//
//  adNetwork.swift
//  Moda
//
//  Created by admin_user on 3/7/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation
import Alamofire
 

extension NetworkManager { 
    
    //MARK: - POST

    func postRegisterData(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<LogIn>?){
 

//        UserAPI.addUser(body: UserInfo(name: "luuser", surname: "fuuser",
//                                       email: "qwe@qwe.zxc",
//                                       phone: "+998909807867",
//                                       address: "line",
//                                       password: "qweqwe")) { login, error  in
//
//                                        if login != nil {
//                                            print(login!)
//                                            answerFunction?(LogIn(token: "qwer", expired: 234234, tokenType: "wertwert"))
//                                        }  else
//
//                                            if error != nil {
//                                                print("swagger error = ", error!.localizedDescription)
//                                        }
//
//                                        errorFunction?(0, error!.localizedDescription)
//
//
//        }
        
        
        sendNetWorkRequest(pathLine: "/register", method: .post,
                           params : params,
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
    
    func postCallUsRequest(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<String>?){
        
        sendNetWorkRequest(pathLine: "/request/call", method: .post,
                           params : params,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    
    func postMessage(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<String>?){
        
        sendNetWorkRequest(pathLine: "/request/message", method: .post,
                           params : params,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    
    func postLogOutRequest(errorFunction : errorClosure?, answerFunction : successTClosure<String>?){
        
        sendNetWorkRequest(pathLine: "/user/logout", method: .post,
                           errorFunction: errorFunction, answerFunction: answerFunction)
        
    }
    
    func postLogInRequest(_ params : [String : Any], errorFunction : errorClosure?, answerFunction :  successTClosure<LogIn>?){
        
//        UserAPI.loginUser(email: params["email"] as! String,
//                          password: params["password"] as! String ) { (login, error) in
//
//            if login != nil {
//                print(login!)
//                answerFunction?(LogIn(token: "qwer", expired: 234234, tokenType: "wertwert"))
//            }  else
//
//            if error != nil {
//                print("swagger error = ", error!.localizedDescription)
//            }
//
//                            errorFunction?(0, error!.localizedDescription)
//
//        }

        sendNetWorkRequest(pathLine: "/login", method: .post,
                           params : params,
                           errorFunction: errorFunction, answerFunction: answerFunction)
        
    }

    
    func postRecoverPassword(_ mail : String, errorFunction : errorClosure?, answerFunction : successTClosure<AccAlive>?){
        
        sendNetWorkRequest(pathLine: "/password/email", method: .post,
                           params : ["email" : mail],
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    
    
    
    func postCardVerification(_ params : [String : Any], errorFunction : errorClosure?,
                              answerFunction : successTClosure<JSONRpcVerifyCode>?){
        
        sendNetWorkRequest(pathLine: NetworkManager.PaymentURL,  pathIsFull : true,  method: .post,
                           params : params,
                           headers: NetworkManager.getHeadersForPayment(),
                           encoding : JSONEncoding.default,
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
 
    func postCardDataVerify(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<JSONRpc>?){
        
        sendNetWorkRequest(pathLine: NetworkManager.PaymentURL,  pathIsFull : true,  method: .post,
                           params : params,
                           headers: NetworkManager.getHeadersForPayment(),
                           encoding : JSONEncoding.default,
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
    
    func postCardData(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<JSONRpc>?){
        
        
        sendNetWorkRequest(pathLine: NetworkManager.PaymentURL,  pathIsFull : true,  method: .post,
                           params : params,
                           headers: NetworkManager.getHeadersForPayment(),
                           encoding : JSONEncoding.default,
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
    
    
    func postOrder(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<[MyOrderModel]>?){
        
        sendNetWorkRequest(pathLine: "/order" , method: .post,
                           params : params,
                           headers: ["X-Auth" : kPayMeAuthKey],
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
 
    func postPayment(_ params : [String : Any], errorFunction : errorClosure?, answerFunction : successTClosure<Payment>?){
        
        sendNetWorkRequest(pathLine: "/payment", method: .post,
                           params : params,
                           headers: ["X-Auth" : kPayMeAuthKey],
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
    
    
    //MARK: - GET
    
    func getPromoDetails(_  errorFunction : errorClosure?, answerFunction : successTClosure<PromoModel>?){
        
        sendNetWorkRequest(pathLine: "/promos", method: .get,
                           params : [:],
                           errorFunction: errorFunction, answerFunction: answerFunction)
        
        
    }

    func getSearchResults(_ query: String, _ gender: Int,
                          errorFunction : errorClosure?, answerFunction : successTClosure<SearchModel>?){
        
        sendNetWorkRequest(pathLine: "/search", method: .get,
                           params : ["q" : query, "gender" : gender],
                           errorFunction: errorFunction, answerFunction: answerFunction)

        
    }
    
    func getFiltersResults(_ params : [String : Any], path : String? = nil,
                           errorFunction : errorClosure?, answerFunction : successTClosure<Collection>?){
 
        let newParams = convertDictToStringDict(params)
        debugLog(newParams)
        
        sendNetWorkRequest(pathLine: path != nil ? path! : "/filter",  pathIsFull : path != nil, method: .get,
                           params : newParams,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    
    func getCategories(errorFunction : errorClosure?, answerFunction : successTClosure<[FullCategoryModel]>?){
        
        sendNetWorkRequest(pathLine: "/categories", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    

    func getMyOrders(_ token : String, errorFunction : errorClosure?, answerFunction : successTClosure<[MyOrderModel]>?){
        
        sendNetWorkRequest(pathLine: "/user/orders", method: .get,
                           params : ["token" : token],
                           errorFunction: errorFunction, answerFunction: answerFunction)

        
    }
    
    
    func getProductInfo(_ productId : Int, errorFunction : errorClosure?, answerFunction : successTClosure<FullProductModel>?){
        
        sendNetWorkRequest(pathLine: "/product/\(productId)", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)
        
    }

    func getImageInfo(_ fullPath : String, errorFunction : errorClosure?, answerFunction : successTClosure<ImageCartn>?){
        
        sendNetWorkRequest(pathLine: fullPath, pathIsFull : true,  method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)

        
    }
    
    func getLogInInfo(_ token : String, errorFunction : errorClosure?, answerFunction : successTClosure<LogInInfo>?){
 
        sendNetWorkRequest(pathLine: "/user?token=\(token)", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
        
    }
  
    func getMainViewModel(_ gender : Int, errorFunction : errorClosure?, answerFunction :  successTClosure<MainModel>?){
        
        sendNetWorkRequest(pathLine: "/mainProductList/\(gender)", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)

        
    }
    
    func getChekOrder(_ orderId : String, errorFunction : errorClosure?, answerFunction : successTClosure<OrderCheck>?){
        
        sendNetWorkRequest(pathLine: "/deliveryStatus/\(orderId)", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
    
    func getAttributes(errorFunction : errorClosure?, answerFunction : successTClosure<AttributesModel>?){
        
        sendNetWorkRequest(pathLine: "/attributes", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)

    }
    
    func getDateModel(errorFunction : errorClosure?, answerFunction : successTClosure<DateModel>?){
        
        sendNetWorkRequest(pathLine: "/delivery", method: .get,
                           errorFunction: errorFunction, answerFunction: answerFunction)
 
    }
}
