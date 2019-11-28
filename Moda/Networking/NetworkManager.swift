//
//  NetworkManager.swift
//  Moda
//
//  Created by Alimov Islom on 8/6/18.
//  Copyright © 2018 moda. All rights reserved.
//
import Foundation
import Alamofire
import Reqres

class NetworkManager {
    
    static let shared: NetworkManager  = NetworkManager ()
    let manager = createSessionManager()

    static var environmentBaseURL: String {
        
        return baseURL + kAPITail 
    
    }

    static var baseURL: String {
        
        return  DEBUG_version ? kMainServer_dev : kMainServer_prod
    }
    
    static var PaymentURL : String {
        
        return SettingsBundleHelper.isCardLiveMode() ? kPaymentServer_prod : kPaymentServer_dev
   
    }
    
    static func createSessionManager() -> SessionManager {
        
        Reqres.logger.logLevel = DEBUG_print ? .verbose : .none
        let configuration = Reqres.defaultSessionConfiguration()
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let alamofireManager = SessionManager(configuration: configuration)
        Reqres.sessionDelegate = alamofireManager.delegate
        
        return alamofireManager
    }
    
    static func getHeadersForPayment() -> HTTPHeaders {
        
        let headers : HTTPHeaders =
            ["X-Auth" : kPayMeAuthKey,
             "Content-Type": "application/json; charset=utf-8"]
        
        return headers
    }
    
}


extension NetworkManager {
     
    
    func  sendNetWorkRequest<T: Codable>( pathLine : String, pathIsFull : Bool = false,
                                          method : HTTPMethod,
                                          params : Parameters? = nil,
                                          headers: HTTPHeaders = [:],
                                          encoding: ParameterEncoding = URLEncoding.default,
                                          errorFunction : ((_ code: Int, _ error: String) -> Void)?,
                                          answerFunction : ((_ model: T) -> Void)?)
    {
        let url = (pathIsFull ? kEmpty : NetworkManager.environmentBaseURL )  + pathLine
        let hdrs = headers.count > 0 ? headers : getHeaders()
                    // getHeaders().merging(headers) { (_, new) in new }
        //URLEncoding.default //  method == .get ? URLEncoding.default : URLEncoding.httpBody
 
        NetworkManager.shared.manager.request(url, method: method,
                          parameters: params,
                          encoding: encoding,
                          headers: hdrs)
            .validate(statusCode: 200..<423) // TODO: - some checks from net are from 400,401,423 errors are Succeeded
            .responseData { (response) in
                
                debugPrint(response)
                
                let codeResponse : Int = response.response?.statusCode ?? 0
 
                switch response.result {
                    
                case .success(let value):
                    
                    if  (codeResponse < 200) || (codeResponse >= 300){
                     
                        var error_line = kEmpty
                        
                        switch codeResponse {
                            case 401 :    error_line = TR("wrong_user_or_pass")
                            case 405 :    error_line = TR("wrong_method_on_server")
                            default  :    error_line = checkForGroupsError(value)
                        }
                        
                        
                        errorFunction?(codeResponse, error_line)
                    
                    } else {
                        
                        
//                        let dataTest = try! JSONSerialization.jsonObject(with: value, options: [])
//                        debugPrint("JSONSerialization", dataTest)

                        
                        parseData(from: value, errorFunction: errorFunction, successFunction: answerFunction)
                    
                    }
                    
                case .failure(let error):
                    let errorCode = codeResponse == 0 ? ( error as NSError ).code : codeResponse
                    let error_text = error.localizedDescription
                    
                    if errorCode == kErrorConnection {
                        
                        let navVC = topTabBarController()?.selectedViewController as? UINavigationController
                        if let uiVC = navVC?.visibleViewController as? BaseViewController {
                            
                            uiVC.showAlert( error_text,   okLine: TR("ok"), noLine: nil, handlerOnNO: nil) {
                                
                                self.sendNetWorkRequest(pathLine: pathLine,
                                                        pathIsFull: pathIsFull,
                                                        method: method, params: params,
                                                        headers: headers,
                                                        encoding: encoding,
                                                        errorFunction: errorFunction,
                                                        answerFunction: answerFunction)
                            }
                            return
                        }
                    }
                    
                    errorFunction?(errorCode, error_text)
                    
                }
                
        }
        
    }
     
    //MARK: - PRIVATE

    
    private func getHeaders() -> HTTPHeaders {
        
        
        var headers : HTTPHeaders =
            [
              "Content-Type" : "application/x-www-form-urlencoded",
              "Accept" : "application/json; charset=UTF-8 ",
              "Cache-Control": "no-cache",
              "currancy"  :  ModaManager.shared.currancy,
              "language"  :  ModaManager.shared.getCurrentLanguage()
        ]
        
        if let token = editLocalToken() {
            if token.count > 0 {
                headers.updateValue("Bearer " + token , forKey:"Authorization")
            }
        }
        
        
        return headers
    }

}


func checkForGroupsError(_ from : Data) -> String {
    do {
        
        let data = try JSONSerialization.jsonObject(with: from, options: [])
        
        //            debugLog(data)
        
        var line = kEmpty
        
        if  let dataDict = data as? [String : Any] {
            
            dataDict.forEach({ (key, value) in
                
                if let error_values = value as? [String : [String]] {
                    error_values.forEach({ (key2, value2) in
                        line += ( value2.joined(separator: "\n") + "\n" )
                    })
                }
                
                if let error_values = value as? [String] {
                    line += ( error_values.joined(separator: "\n") + "\n" )
                }
                
                if let error_value = value as? String {
                    line += ( error_value + "\n" )
                }
                
            })
        }
        
        //            if  let dataArr = data as? [Any] {
        //               debugLog(dataArr)
        //            }
        
        return line == kEmpty ? "Invalid request message" : line
        
    } catch {
        
        return error.localizedDescription
        
    }
}

func parseMessageLine(_ data : Data,  _ errorFunction : errorClosure?, _ answerFunction : successStringClosure?) {
    
    do {
        
        let data = try JSONSerialization.jsonObject(with: data, options: []) as? String
        
        if data != nil {
            answerFunction?(data!)
        } else {
            errorFunction?(0, "Empty data")
        }
        
    } catch {
        
        let errorNS : NSError = error as NSError
        errorFunction?(errorNS.code, error.localizedDescription)
        
    }
}

