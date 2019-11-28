//
//  Helper.swift
//  Moda
//
//  Created by admin_user on 11/2/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation
import AlamofireImage


struct SocialModel : InitModel{
    let name : String
    let name_link : String
    let app_link : String
    let net_link : String
}


enum SocialType {
    case facebook
    case telegram
    case instagram
    case viber
    case whatsapp
    case ok
    case vk
    case web
}


func getSocialModelFrom(_ social_name : SocialType ) -> SocialModel {
    
    switch social_name {
        
    case .facebook:
        return SocialModel(name: "facebook",
                           name_link: kFaceBookAt,
                           app_link:  "https://m.facebook.com/" + kFaceBookAt,
                           net_link:  "fb://profile/" + kFaceBookAt)
        
    case .telegram:
        return SocialModel(name: "telegram",
                           name_link: kTelegramAt,
                           app_link:  "https://t.me/" + kTelegramAt,
                           net_link:  "tg://resolve?domain=" + kTelegramAt)
    case .instagram:
        return SocialModel(name: "instagram",
                           name_link: kInstagramAt,
                           app_link:  "https://instagram.com/" + kInstagramAt,
                           net_link:  "")

    case .viber:
        return SocialModel(name: "Viber",
                           name_link: kViberAt,
                           app_link:  "https://www.viber.com/" + kViberAt,
                           net_link:  "viber://add?number=" + kViberAt)

    case .whatsapp:
        return SocialModel(name: "WhatsApp",
                           name_link: kWhatsApAt,
                           app_link:  "https://whatsapp.com/" + kWhatsApAt,
                           net_link:  "whatsapp://send?phone=" + kWhatsApAt)
        
        
    case .vk:
        return SocialModel(name: "VK",
                           name_link: kVKAt,
                           app_link:  "https://vk.com/" + kVKAt,
                           net_link:  "vk://send?" + kVKAt)
        
        
    case .ok:
        return SocialModel(name: "OK",
                           name_link: kOKAt,
                           app_link:  "https://ok.ru/" + kOKAt,
                           net_link:  "ok://send?phone=" + kOKAt)
    
    
    default:
        return SocialModel(name: "Moda",
                           name_link: kSiteForShareShort,
                           app_link:  kiOSAppLink,
                           net_link:  kSiteForShare)
    }
    
}

func editItemInUserDefaults(_ key : String, _ item : String? = nil) -> String? {
    
    if item == kEmpty {
        saveInLocal(key, nil)
    } else
        if item != nil {
            saveInLocal(key, item!)
        }
 
    return getFromLocal(key) as? String
    
}


func openLinkCheckOrder() {
    
     openWebPageFrom(NetworkManager.baseURL + upperSupportLinks[0], upperSupportTitle[0])
    
}

func callPhone(_ phone : String = supportPhoneNumberDial) {
    
    _ = openUrlFrom("tel://\(phone)", kEmpty)
    
}


func openSocialPage(_ social : SocialType) {
   
    let model = getSocialModelFrom(social)
 
    if !openUrlFrom(model.app_link) {
        
        _ = openUrlFrom(model.net_link)
    }
}

//MARK: - UIKIT and Common


func showAlertFromLocalReadWrite(_ error : String) {
    
    debugLog(error)
    
}

func editLocalToken(_ token : String? = nil, expired : Int? = nil) -> String? {
    
    if expired != nil { saveInLocal("expired", expired) }

    return editItemInUserDefaults("token", token)
    
}


func editViewList( products: [Product]? = nil, _ addAction : Bool = false, errorFunction: errorStringClosure? = nil , answerFunction : productsListClosure?) {
    
    editListInMemory(listName: "view",
                     badgeNumber: -1,
                     fullEqual: true,
                     products : products, addAction : addAction,
                     errorFunction: errorFunction, answerFunction: answerFunction)
    
}

func editBagList( products: [Product]? = nil,  addAction : Bool = false, countAmount : Bool = true , errorFunction: errorStringClosure? = nil , answerFunction : productsListClosure?) {
    
    editListInMemory(listName: "bag",
                     badgeNumber: 4,
                     fullEqual: true, countAmount: countAmount,
                     products : products, addAction : addAction,
                     errorFunction: errorFunction, answerFunction: answerFunction)

    
}

func editFavoriteList( products: [Product]? = nil,  addAction : Bool = false,  errorFunction: errorStringClosure? = nil , answerFunction : productsListClosure?) {
    
    editListInMemory(listName: "favorites",
                     badgeNumber: 2,
                     fullEqual: false,
                     products : products, addAction : addAction,
                     errorFunction: errorFunction, answerFunction: answerFunction) 
    
}

func isItemInFavorites(_ cell : ProductCollectionViewCellMain) {
    
    editFavoriteList { favorites in
        
        cell.isFavorite  =  favorites.contains(where: { item -> Bool in
            item.isEqualToProduct(cell.data!, false)
        })
        cell.heart.drawHeart(in: cell.bounds, isFilled: cell.isFavorite)
        
    }
}

func isItemInFavorites(_ cell : ProductCollectionViewCell) {
    
    editFavoriteList { favorites in
        
        cell.isFavorite  =  favorites.contains(where: { item -> Bool in
            item.isEqualToProduct(cell.data!, false)
        })
        cell.heart.drawHeart(in: cell.bounds, isFilled: cell.isFavorite)
        
    }
}


func clearMemoryFromReadyOrder(){
    
    editBagList(products: nil, addAction : true, answerFunction: nil)
}


func fullVersionOfApp() -> String {
    
    return getAppVersion() + "(" + getBuildNumber() + ")"

}

func setNicePrices(_ variation : Variation,_ newPrice : inout UILabel, _ oldPrice: inout UILabel) {

    oldPrice.text = kEmpty
    newPrice.text = setNiceCurrancy(variation.price)
    
    if let price2 = variation.price2, price2 > 0  {
        oldPrice.attributedText = NSAttributedString(
            string: setNiceCurrancy(price2),
            attributes: [.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
        )
    }
}

func loadNetImage(_ imgUrlNew : URL?, _ contentView : UIView, _ imgView : UIImageView?){
    
    guard imgUrlNew != nil   else { return }
    
    let spinner = UIActivityIndicatorView()
    spinner.color = kColor_AppLightSilver
    contentView.addSubview(spinner)
    spinner.center = imgView?.center ?? CGPoint.zero
    spinner.startAnimating()
    
    imgView?.af_setImage(
        withURL: imgUrlNew!,
        imageTransition: .crossDissolve(0.1),
        runImageTransitionIfCached: true
    ) { responce in
        
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}


// MARK: - extensions

extension UIViewController {

    func setColorsOnVC(){
        
        navigationItem.leftBarButtonItem?.tintColor = kColor_AppBlack
        navigationItem.rightBarButtonItem?.tintColor = kColor_AppBlack
        navigationItem.backBarButtonItem?.tintColor = kColor_AppBlack
    }
    
    func hideLineOfTabBar(_ hide : Bool ){
        navigationController?.navigationBar.setValue(hide, forKey: "hidesShadow")
 
    }
}



extension UITableViewCell {
    
    @objc func setUpCellWithData(_ dataModel : Any){
        
    }
}



extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }
}



func parseData<T: Codable>(from data: Data?,
                                   errorFunction : errorClosure?,
                                   successFunction : ((_ model : T) -> Void)?) {
    
    if data == nil {
        errorFunction?(kErrorJSONDecoder, "Empty data")
        return
    }
    
    if  T.self == String.self {
        if let json = String(data: data!, encoding: String.Encoding.utf8) {
            successFunction?(json as! T)
        } else {
            errorFunction?(kErrorJSONDecoder, "Not A String data")
        }
        return
   }
    
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let model = try decoder.decode(T.self, from: data!)
        successFunction?(model)
    } catch {
        
        checkErrorLineInAnswer(from: data, errorFunction: errorFunction, error.localizedDescription)
    }
    
}


func checkErrorLineInAnswer(from data: Data?, errorFunction : errorClosure?, _ parseError : String){
    
    do {
        let model = try JSONDecoder() .decode(Dictionary<String, String>.self, from: data!)
        if let error = model["error"]  {
            errorFunction?(kErrorFromServerApi, error)
        } else {
            errorFunction?(kErrorJSONDecoder, parseError)
        }
    } catch {
        errorFunction?(kErrorJSONDecoder, error.localizedDescription)
    }
}
