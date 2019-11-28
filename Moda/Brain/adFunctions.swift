//
//  adFunctions.swift
//  Moda
//
//  Created by admin_user on 3/7/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Localized


func TR(_ str: String?) -> String{
    
    
    if str == nil {
        return kEmpty
    }
    return NSLocalizedString(str!,  comment: " ")
    
}

//MARK: - LocalSettings

func  getAppVersion() -> String
{
    if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    {
        return "\(appVersion)"
    }
    return kEmpty
}

func getBuildNumber() -> String
{
    if let buildNum = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String)
    {
        return "\(buildNum)"
    }
    return kEmpty
}

func openSettingsApplication(){
    
    if let url = URL(string: UIApplicationOpenSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

func registerNotifications(){
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.attempRegisterForNotifications(UIApplication.shared)
    
}


var modelForDelivery : DateModel?


func getDeliveryModel(_ answerReturn :  emptyClosure?){
 
    guard modelForDelivery == nil else {
            answerReturn?()
            return
    }
    
    NetworkManager.shared.getDateModel(errorFunction: { num, error  in
        debugLog("NetworkManager.shared.getDateModel = " + error)
        answerReturn?()

    }) { model in
        
        modelForDelivery = model
        
        answerReturn?()
    }
}

func chooseDeliveryDateLine(_ type : DeliveryType, withDescription : Bool = true) -> String {
    
    let answer =  withDescription ? TR("delivery_date") + " " : kEmpty
    let initDate = Date().fromDateToString()
    
    switch type {
    case .AFTER_TOMORROW:
        let today = Date()
        if let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today) {
            let initDate = nextDate.fromDateToString()
            
            return answer + initDate
        }
    case .TODAY_FITTING:
        return answer + initDate
    default:
        let newDate = modelForDelivery?.methods[type.name]?.date.getDateFromString()
        
        return answer + (newDate?.fromDateToString() ?? initDate)
    }
    
    return ""
}


func getDeliveryPrice(for type : DeliveryType) -> Int {
    if let price = modelForDelivery?.methods[type.name]?.price {
        return price
    }
 
    getDeliveryModel(nil)
    
    return kDefaultSUmForDelivery
    
    
}

//MARK: - Network Help

func convertDictToStringDict(_ oldDict : [String : Any]) -> [String : String]{
    
    var newDict = [String: String]()
    
    oldDict.forEach{
        
        if let arrValues = $0.value as? [Any] {
            newDict[$0.key] = (arrValues as NSArray).componentsJoined(by: ",")
        } else {
            newDict[$0.key] = "\($0.value)"
        }
 
    }
    
    return newDict
}


//MARK: - LOG


func debugLog(_ items: Any){
    
    if DEBUG_print {
        print(items)
    }
    
}

func showErrorAnswerFromNet(_ functionName : String, _ error : String, showError : Bool = false ){
    showErrorAnswer(functionName, nil, showError: showError, errorLine: error)
}
func showErrorAnswer(_ functionName : String, _ error : Error?, showError : Bool = false, errorLine : String? = nil){
    
    let errorStr = error?.localizedDescription ?? errorLine ?? kEmpty
    
    debugLog("------- \(functionName) -------\n")
    debugLog("\(errorStr)\n")
    
    if showError {
        
        guard let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController else {
            return
        }
        
        if errorLine != kEmpty {
            rootViewController.showAlert(errorStr)
        }
    }
    
}

func debugPrint(title: String,  _ value : Any){
    
    guard DEBUG_print else { return }
    
    do {
        
        var jsonStr: Any = "no value"
        
        if let vauleData = value as? Data {
            jsonStr = try JSONSerialization.jsonObject(with: vauleData, options: []) as Any
        } else
            if let vauleStr = value as? String {
                jsonStr = vauleStr
        }
        
        print("\n------- DEBUG PRINT - " + title + " -------\n")
        print(jsonStr, "\n")
        
    } catch {
        
        showErrorAnswer("DEBUG PRINT in " + title , error)
    }
    
}


//MARK: - Functional Logic

extension Int {
    
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
    
}


func cutPrefixFromPhone(_ phone : String) -> String {
    
    return String(phone.suffix(9))
    
}

func setNiceNumber( _ number : Any, _ withCurrancy : Bool = false) -> String {
    let niceFormat = NumberFormatter()
    niceFormat.usesGroupingSeparator = true
    niceFormat.numberStyle = .none

    if withCurrancy {
        niceFormat.numberStyle = .currency
        niceFormat.locale = Locale(identifier: ModaManager.shared.currancy)
    }

    if let  numberV = number as? Int {
        return niceFormat.string(from: NSNumber(value: numberV))!
    }
    
    if let  numberV = number as? Double {
        return niceFormat.string(from: NSNumber(value: numberV))!
    }
    
    if let  numberV = number as? Float {
        return niceFormat.string(from: NSNumber(value: Double(numberV)))!
    }
    
    if let  numberV = number as? CGFloat {
        return niceFormat.string(from: NSNumber(value: Double(numberV)))!
    }
    
    

    return "0"

}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}


func setNiceCurrancy( _ number : Any) -> String {

    return setNiceNumber(number, true)
}

func getFormattedPhoneNumber(_ number: String) -> String {
    
    let s = number
    
    if number.count < 12 {
        return number
    }
    
    return String(
        format: "%@ (%@ %@) %@ %@ %@",
        String(s[..<s.index(s.startIndex, offsetBy: 1)]),
        String(s[s.index(s.startIndex, offsetBy: 1) ..< s.index(s.startIndex, offsetBy: 4)]),
        String(s[s.index(s.startIndex, offsetBy: 4) ..< s.index(s.startIndex, offsetBy: 6)]),
        String(s[s.index(s.startIndex, offsetBy: 6) ..< s.index(s.startIndex, offsetBy: 9)]),
        String(s[s.index(s.startIndex, offsetBy: 9) ..< s.index(s.startIndex, offsetBy: 11)]),
        String(s[s.index(s.startIndex, offsetBy: 11) ..< s.index(s.startIndex, offsetBy: 13)])
    )
}

func setFormattedDates(from data1: Date, to data2: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru-RU")
    dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy HH:mm")
    let dateObj1 = dateFormatter.string(from: data1)
    let dateObj2 = dateFormatter.string(from: data2)
    return dateObj1 + " 一 " + dateObj2
}

//MARK : - UserDefaults

func getFromLocal(_ key : String) -> Any?  {
    
    return UserDefaults.standard.object(forKey: key)
}

func saveInLocal(_ key : String, _ item : Any? ) {
    
    if item == nil {
        UserDefaults.standard.removeObject(forKey: key)
    } else {
        UserDefaults.standard.setValue(item, forKey: key)
    }
    UserDefaults.standard.synchronize()
}

//MARK : - main


func getFromMemory(from: String, errorFunction : errorStringClosure?, productsFunction : productsClosure?){

    let folder = from.capitalizingFirstLetter()

    let app = UIApplication.shared.delegate as! AppDelegate
    
    DispatchQueue.global(qos: .userInitiated).async {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(folder +  kSlash + from + ".json") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            var data = [Product]()

            if fileManager.fileExists(atPath: filePath) {

                let jsonStr = app.read(from: from, folder: folder)
                
                DispatchQueue.main.async {
                    do {

                        if let jsonData = jsonStr?.data(using: .utf8) {
                           data = try JSONDecoder().decode([Product].self, from: jsonData)
                        }
 
                        productsFunction?(&data)
                        
                        writeDataInFile(data, from, errorFunction: errorFunction)
 
                    } catch {
                        errorFunction?(from + kSemicolons + "decode " + error.localizedDescription)
                     }
                }
            } else {
 
               writeDataInFile(data, from, errorFunction: errorFunction)
            }
        }
    }
}


func writeDataInFile(_ data : [Product], _ fileName : String, errorFunction : errorStringClosure?) {

    let folder = fileName.capitalizingFirstLetter()

    DispatchQueue.main.async {
        do {
            let app = UIApplication.shared.delegate as! AppDelegate

            let jsonData = try JSONEncoder().encode(data)
            let jsonStr = String(data: jsonData, encoding: .utf8)
            app.write(text: jsonStr!, to: fileName, folder: folder)
            
        } catch {
            errorFunction?(fileName + kSemicolons + "encode " + error.localizedDescription)
        }
    }
}


func editListInMemory( listName : String,
                       badgeNumber : Int,
                       fullEqual : Bool ,
                       countAmount : Bool = false ,
                       products: [Product]? = nil,
                       addAction : Bool = false,
                       errorFunction: errorStringClosure?,
                      answerFunction : productsListClosure?) {
    
    let funcForError : errorStringClosure =  errorFunction ?? showAlertFromLocalReadWrite
    
    getFromMemory(from: listName, errorFunction: funcForError ) { (data : inout [Product]) in
        
        if products != nil {
            
            if !addAction {
                
                var newData = [Product]()

                for product in products! {
                    
                    newData = data.filter {
                        !$0.isEqualToProduct(product,fullEqual)
                    }
                    
                    if countAmount {
                        var deleteData = [Product]()
                        
                        deleteData = data.filter {
                            $0.isEqualToProduct(product,fullEqual)
                        }
                        
                        if var item =  deleteData.first {
                            item.count = (item.count ?? 1)  - (product.count ?? 1)

                            if item.count! > 0 {
                                newData.append(item)
                            }
                        }
                       
                    }
                   
                    data = newData
                }
                
            } else {
 
                var lastProducts = products!.map { $0 }
                
                for  i in 0..<products!.count {
                    for  j in 0..<data.count {
                     
                        if data[j].isEqualToProduct(products![i],fullEqual){
                            let count = data[j].count ?? 1
                            
                            data[j] = products![i]
                            
                            if countAmount {
                             data[j].count =  count + ( products![i].count ?? 1)
                            }
                            
                            lastProducts.remove(at: i)
                        }

                    }
                    
                }
                
                data.append(contentsOf: lastProducts)
            }
            
        }  else {
            
            if addAction {
                data.removeAll()
            }
        }
        
        if badgeNumber > 0
        {
            var countAll = Int(0)
            for item in data {
                countAll += (item.count ?? 1)
            }
            refreshBadgeNumber(badgeNumber, countAll)
        }
        
        answerFunction?(data)
    }
}


func getIdForAppNotificstions(_ deviceToken: Data) -> String{
    
    let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
    var tokenString = kEmpty
    
    for i in 0..<deviceToken.count {
        tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    return tokenString
}

//MARK: - UIKIT STORYBOARD


func refreshBadgeNumber(_ badgeNumber : Int, _ newCount : Int){
        
    let application = UIApplication.shared.delegate as! AppDelegate
    let tabbarController = application.window?.rootViewController as! UITabBarController
    tabbarController.tabBar.items?[badgeNumber].badgeValue =  newCount == 0 ? nil : "\(newCount)"
    
}


func getVCFromMain(_ nameOfController : String = kEmpty, _ storyBoard : String = "Main" ) -> UIViewController {
    
    let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
    
    if nameOfController == kEmpty {
        return storyboard.instantiateInitialViewController()!
     } else {
        return storyboard.instantiateViewController(withIdentifier: appIdentifier +  "." + nameOfController)
     }
 }

func changeVCInTabBarController(_ newVC : UIViewController ){

    if let currentVC = topTabBarController()?.selectedViewController as? UINavigationController {
        currentVC.navigationBar.tintColor = kColor_Black
        currentVC.visibleViewController?.navigationController?.pushViewController(newVC, animated: true)
    }
}


func getBlurredHeight() -> CGFloat {
 
    let shift : CGFloat = topTabBarController()?.tabBar.frame.origin.y ?? 0
    return UIScreen.main.bounds.height - shift
    
}

func getUpperShiftFromAnyScreen() -> CGFloat {

   return topTabBarController()?.tabBar.frame.origin.y ?? 30

}

func getBlurredHeightForFull() -> CGFloat {

    let shift : CGFloat = topTabBarController()?.tabBar.frame.origin.y ?? UIScreen.main.bounds.height
    return UIScreen.main.bounds.height - shift
    
}



func searchBarCustomize() {
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = TR("cancel").capitalizingFirstLetter()
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = kColor_AppBlack
}


func openWebPageFrom(_ site_link : String, _ title : String){

    if let currentVC = topTabBarController()?.selectedViewController as? UINavigationController {
        
        let webVC = getVCFromMain("WebViewOverlay") as! WebViewOverlay
        webVC.path = site_link + linkTail
        webVC.title = TR(title)
 
        let backItem = UIBarButtonItem()
        backItem.title = kEmpty
        
        backItem.tintColor = kColor_AppBlack
        currentVC.topViewController?.navigationItem.backBarButtonItem = backItem
        currentVC.topViewController?.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
}
 
func openUrlFrom(_ pathLine : String, _ tail : String = linkTail) -> Bool {
    
    if let url = URL(string: pathLine + tail) {
        
        if UIApplication.shared.canOpenURL(url) {
            
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            return true
        }
        
    }
    
    return false
    
}

func onClearMemoryIfWarning(){
    
    guard  let tabBarVC = topTabBarController()  else { return }
    guard  let tabBarVCs = tabBarVC.viewControllers  else { return }

    for itemNav in tabBarVCs {
        
        if let navController = itemNav as? UINavigationController {
            let cntrllrs = navController.viewControllers
            if cntrllrs.count > 2 {
                navController.setViewControllers([cntrllrs.first!,cntrllrs.last!], animated: false)
            }
        }
    }
} 

func topTabBarController() -> UITabBarController? {
    
    guard var top = UIApplication.shared.keyWindow?.rootViewController else {
        return nil
    }
    
    while let next = top.presentedViewController {
        top = next
    }
    
    return top as? UITabBarController
}


//MARK: - EXTENSIONS


public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UIColor {
    static var random: UIColor {
        return UIColor(
            hue: CGFloat(arc4random_uniform(.max)) / CGFloat(UInt32.max),
            saturation: 1,
            brightness: 1,
            alpha: 1
        )
    }
}

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}




extension Data {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            debugLog("error: \(error.localizedDescription)")
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? kEmpty
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? kEmpty
    }
}



// MARK: - String extension

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}


extension UIView {
    @objc  func reloadTranslations(){
        
    }
}

extension UIViewController {
    @objc func reloadTranslations(){
        
    }
}

extension Dictionary {
    
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

