//
//  ModaManager.swift
//  Moda
//
//  Created by Alimov Islom on 8/14/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

class ModaManager {
 
    static let shared = ModaManager()
 
    var profile : LogInInfo?
    
    var currancy : String = kCurrancyDefault
 
    var language : String = kLanguangeDefault

    var country : String = kCountryDefault

    var countries : [CountryModel] = kCountryDefaultList
    
    var filters : [String : Any] = [:]

    var selectedGender = 0

    var appDiscount : Double? 

    func getCurrentLanguage() -> String{
        
        return language 
    }

    func getDiscountInfo(){
        
        guard appDiscount == nil else { return }
        NetworkManager.shared.getPromoDetails(nil) { promo in
            if promo.status {
                self.appDiscount = Double(promo.amountPercent)
            }
        }
    }
    
    func setModaInroduced() {
        
        saveInLocal(kModaIntroduction, true)
    }
    
    func getModaFirstLaunch() -> Bool   {
        
        return getFromLocal(kModaIntroduction) as? Bool ?? false
    }
    
    
    func setModaNotificationReminer(_ str : String) {
        UserDefaults.standard.setValue(str, forKey: kModaNotificationReminder)
        UserDefaults.standard.synchronize()
    }
    
    func getModaNotificationReminder() -> String?   {
        return UserDefaults.standard.string(forKey: kModaNotificationReminder)
    }
     
    
    func getCurrentVersionInfo() -> String {
        
        return getFromLocal(kModaVersionInfo) as? String ?? kEmpty
    }
    
    func setVersionInfo( info : String)  {
        
        saveInLocal(kModaVersionInfo, info)
 
    }
    
    
    func getProfile() -> LogInInfo? {
        
        return self.profile
    }
    
    func setProfile( _ profile: LogInInfo?)  {
        
        self.profile = profile
        
    }
    
    
}
