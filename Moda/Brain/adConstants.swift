//
//  adConstants.swift
//  Moda
//
//  Created by admin_user on 3/7/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation

//MARK: - Typealias


typealias errorClosure = ((_ code: Int, _ error : String) -> Void)
typealias errorStringClosure = (( _ error : String) -> Void)
typealias successTClosure<T : Codable> = ((_ model : T) -> Void)
typealias successClosure = ((_ model : Codable) -> Void)
typealias successStringClosure = ((_ line : String) -> Void)
typealias productsClosure = ((_ data : inout [Product]) -> Void)
typealias productsListClosure = ((_ data : [Product]) -> Void)
typealias emptyClosure = (() -> Void)
typealias vcPreInitClosure = ((_ vc : inout UIViewController) -> Void)




//MARK: - Letters

let kEmpty = ""
let kSemicolons = ": "
let kCommaWithEmpty  = ", "
let kSlash = "/"
let kAllLetters  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


//MARK: - Fonts

let kFont_normal = "HelveticaNeue"
let kFont_medium = "HelveticaNeue-Medium"
let kFont_bold = "HelveticaNeue-Bold"
let kFont_bbold = "HelveticaNeue-Black"
let kFont_llight = "HelveticaNeue-Light"

//MARK: - Colors
//if #available(iOS 11.0, *) {
//
//    let kColor_AppBlack  = UIColor(named: "appBlack")! // 35 31 32
//    let kColor_AppOrange =  UIColor(named: "appOrange")! // 254  106 0
//    let kColor_AppDarkViolet =  UIColor(named: "appDarkViolet")! // 56
//    let kColor_AppGrayishOrange = UIColor(named: "appGrayishOrange")! // 153, 147, 142
//    let kColor_AppLightGray = UIColor(named: "appLightGray")! // 227, 227, 227
//    let kColor_AppLightGrayTag = UIColor(named: "appLightGrayTag")! // 236, 236, 236
//    let kColor_AppLightSilver = UIColor(named: "appLightSilver")! // 197, 193, 190
//
//} else {


    let kColor_AppBlack  = UIColor(displayP3Red: 35/225, green: 31/225, blue: 32/225, alpha: 1)
    let kColor_AppOrange = UIColor(displayP3Red: 254/225, green: 106/225, blue: 0/225, alpha: 1)
    let kColor_AppDarkViolet =  UIColor(displayP3Red: 52/225, green: 42/225, blue: 61/225, alpha: 1)
    let kColor_AppGrayishOrange = UIColor(displayP3Red: 153/225, green: 147/225, blue: 142/225, alpha: 1)
    let kColor_AppLightGray = UIColor(displayP3Red: 227/225, green: 227/225, blue: 227/225, alpha: 1)
    let kColor_AppLightGrayTag = UIColor(displayP3Red: 236/225, green: 236/225, blue: 236/225, alpha: 1)
    let kColor_AppLightSilver = UIColor(displayP3Red: 197/225, green: 193/225, blue: 190/225, alpha: 1)
//
//}




let kColor_White =  UIColor.white
let kColor_Blue =  UIColor.blue
let kColor_DarkGray =  UIColor.darkGray
let kColor_Gray =  UIColor.gray
let kColor_LightGray =  UIColor.lightGray
let kColor_Black     =  UIColor.black
let kColor_Red      =  UIColor.red
let kColor_No     =  UIColor.clear


// MARK: - Errors Internal Codes

let kErrorJSONDecoder = -1
let kErrorInnerStructure = -2
let kErrorJSONFormat = -3
let kErrorFromServerApi = -4
let kErrorEmpty = 0
let kErrorConnection = -1009

// MARK: - LINKS TAILS


let supportContactsLink =  "/pages/contacts"


let upperSupportLinks = ["/check-order",
                         "/pages/dostavka",
                         "/pages/gid-po-razmeram"]


let  middleSupportLinks = ["/check-order",
                           "/pages/oplata",
                           "/pages/usloviya-vozvrata",
                           "/pages/dostavka",
                           "/pages/gid-po-razmeram",
                           "/pages/kak-oformit-zakaz-poshagovaya-instruktsiya",
                           "/pages/oferta"]

let  middleSupportLinks_old = ["/pages/kak-oformit-zakaz-poshagovaya-instruktsiya",
                           "/pages/dostavka",
                           "/pages/oplata",
                           "/pages/usloviya-vozvrata",
                           "/pages/oformlenie-zakaza-v-ios-prilozhenie"]



// MARK: - INNERS DATA
 

let kProfileCellName = ["globe",
//                        "my_orders",
                        "check_order_status"]

let kProfileCellControllers = ["CountryChooseViewController",
                              "MyOrdersViewController",
                               "CheckOrder"]

let kSupportCellName = [ "question_ask",
                         "call_us",
                        "call_you_"]

let kSupportCellControllers = [
                               "MessageOrderViewController",
                               "OurContactsTableViewController",
                               "CallOrderViewController"]


let kSupportCellName2 = [
//    "faq",
    "support_service_MOD",
    "about_MOD"]

let kSupportCellControllers2 = [
//    "SupportCenterViewController",
    "SupportCenterViewController",
    "OurContactsTableViewController"]




let upperSupportTitle = ["find_order_status",
                         "find_conditions",
                         "choose_right_size"]


let middleSupportLabels = ["order_with_number",
                           "payment_conditions",
                           "return_conditions",
                           "delivery_conditions",
                           "how_choose_size",
                           "how_make_order",
                            "oferta"]


let middleSupportLabels_old = ["how_make_order",
                           "delivery",
                           "payment",
                           "return_conditions",
                           "make_order_stuff"]

let searchSections =  ["brands",
                       "categories",
                       "goods"]

let namesOfGenderTabs = ["woman_selector",
                         "man_selector",
                         "children_selector",
                         "home_selector"]
 


let nameOfMainTabs = [ "selection",
                       "catalog",
                       "favorites",
                       "profile",
                       "basket"]

let sortingVariants = ["on_popularity",
                       "on_price_upp",
                       "on_price_down",
                       "on_new",
                       "on_discounts"]

var namesOfPaymentTypes = ["payme",
                           "click",
                           "visa",
                           "mastercard"]


let kTimeIntervals  = ["8:00-9:00",
                       "9:00-10:00",
                       "10:00-11:00",
                       "11:00-12:00",
                       "12:00-13:00",
                       "13:00-14:00",
                       "14:00-15:00",
                       "15:00-16:00",
                       "16:00-17:00",
                       "17:00-18:00",
                       "18:00-19:00",
                       "19:00-20:00",
                       "20:00-21:00",
                       "21:00-22:00"]


let deliveryConidtions = [ "delivery_time_today", "delivery_time_hour"]

let addressPartsNames = ["region","street","house","flat"]

let deliveryKeyTypes : [DeliveryType] = [.TODAY_FITTING, .IN_HOUR]
