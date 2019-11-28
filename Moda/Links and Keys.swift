//
//  Names.swift
//  Moda
//
//  Created by Alyona Din on 11/2/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

//MARK: -  POD settings
 
 /*
 
To remove Warning: “-pie being ignored. it is only used when linking a main executable”
 
 -> Disable -pie for Pods
 To enable position-dependent code (and hence remove -pie, which is Position Independent Code), after opening the xcworkspace, go to the Pods project build settings (the settings for the whole Pods project, see screenshot), search for position and set the Generate Position-Dependent Code build setting to Yes.
 
 
 
 in LUAutocompleteView
 
  private textFieldEditingChanged -> not public
 
 
 
 
 
 */
 

//MARK: - DEBUG MARKS

let DEBUG_version    = false
let DEBUG_payment    = false
let DEBUG_print      = true
let DEBUG_net_off    = false




// MARK: - KEYS

let kGoogleKey = "AIzaSyDaQ5243Yh-9dTw5FMe7zTdBukM_xmxbjE" //"AIzaSyDRv07Aqslv1kXjgJWhn2x8Thab_7TgA1I"

let kPayMeAuthKey = "5b0298f28f79903b6a386113" 

let appIdentifier = "uz.moda"

// MARK: SERVERS

let kMainServer_dev = "https://dev.mod.uz"
let kMainServer_prod = "https://mod.uz"

let kPaymentServer_dev = "https://checkout.test.paycom.uz/api"
let kPaymentServer_prod = "https://checkout.paycom.uz/api"


let kAPITail = "/api"
let linkTail = "?fromapp=true"


let paymeOfferLink = "https://cdn.payme.uz/terms/main.html"


// MARK: - Contacts


let kSiteForShare =  "https://mod.com/"
let kSiteForShareShort =  "mod.uz"
let kiOSAppLink    =  "mod://"

let kAppLinkWeb   =  "https://mod.uz"

let kTelegramAt   =  "@mod_uz"
let kFaceBookAt   =  "mod.uz.75"
let kInstagramAt  =  "mod.uz?igshid=10r1be68jbc3n"


let kWhatsApAt  =  "mod.uz"
let kViberAt  =  "mod.uz"
let kOKAt  =  "profile/588037976332"
let kVKAt  =  "id561035939"




let supportPhoneNumber = "+998 95 303-99-99"

let supportPhoneNumber1 = "+998 95 303-99-99"
let supportPhoneNumber2 = "+998 95 303-99-99"



let supportPhoneNumberDial = "+998953039999"


// MARK: - PAYMENTS

//  - -  -  - - -Payme- - - - - - - -
//
//    var testcard = "8600 1434 1777 0323"
//    var testcarddate = "03 20"
//    var testsmsCode = "666 666"
//    var testVal = 1000
//
//let testToken = "NWIzY2M3NWQzYWMwZDdlYzhiMzRmNGYxX094dG1wMktjJUJvLV8xK0daKHMl4oSWUUZUKm9aR3AjT0p4NTIyS3jihJZBeEojOUV3YkQxIWVRZzBfdEA3JlRJNiVkaSFCa1JiQC0qbmdKVXJZJkZyMmtuMEt0aFpWMyFQRTRIT09uWURDamtCYnBEU3lhKG40c19FdUpXUCZSci1GUjF4WW1TUCFJb2s/PT0xcj85Tkd34oSWVSYmTmFfcjVOPXcoMWEjQ3AqQHdyKyt6SSFDRzAhViZ5WDl1PWlNUG9INWotKTYqbzYmN3Y9JSRTSld5Z1VuQSkhKCRjKOKElj81VWJrWShxZmlDNiVHK3ZFSD1VdjE0ayRyQEFNdUs/NU9eZA=="


//MARK: - Internal Keys  

let kModaIntroduction = "modaIntroduction"
let kModaVersionInfo = "versionInfo"
let kModaNotificationReminder = "NotificationReminder"

//MARK: - Settings

let kDefaultPercentForExpressDelivery = 0.15
let kDefaultPercentOfPriceForHalfDelivery = 0.3
let kDefaultSUmForDelivery = 0
let kMaxOnlinePayment = 1_500_000
let kDefaultStartDayOfDelivery = 2
let kDefaultDaysForDelivery = 5


let kCurrancyDefault = "uz_UZ"
let kCountryDefault = "uz"
let kLanguangeDefault = "ru"
let kPhonePrefixDefault = "+998"


var kCountryDefaultList: [CountryModel] = [CountryModel(name: "Uzbekistan", code: "uz")] //,  CountryModel(name: "Россия", code: "ru")]


//MARK: API Keys

let priceFromTo : [CGFloat] = [10000, 1000000]

//FIXME: 200 - Actually, I dont know the index of 4th column (Для дома)
let indexesOfTopMenuChoose = [1,2,109,200]


//MARK: -

enum DeliveryType: Int, Codable {
    case TODAY_FITTING, IN_HOUR, AFTER_TOMORROW
    
    var name: String {
        get { return String(describing: self) }
    }
    
}
 
enum PaymentType: String, Codable {
    case payme, click, visa, mastercard, cod
}
 
enum AmountType: String, Codable {
    case full, percent, zero
    // case ALL, PERCENT, ZERO
}


