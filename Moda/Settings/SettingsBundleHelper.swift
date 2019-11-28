//
//  SettingsBundleHelper.swift
//  vPremiere
//
//  Created by Abhilash on 28/03/17.
//  Copyright © 2017 Mobiotics. All rights reserved.
//

import Foundation


var firstEnterSession = true

func saveLang(_ newLang : String){
    
    ModaManager.shared.language = newLang
    
    saveInLocal("id_language", newLang)

    Bundle.setLanguage(newLang)
    
}


class SettingsBundleHelper {
 
    class func updateAfterEnterApp(){

        getCurrentLanguage()
        
        getCurrentCurrancy()
        
        setVersionAndBuildNumber()
        
    }
    
    class func updateAfterAwakeApp(){
 
        if let lang = getFromLocal("id_language") as? String {
            
            if Locale.current.languageCode != lang {
                
                saveLang(lang)
                topTabBarController()?.reloadTranslations()
            } 
            
        }
    }

    class func getCurrentCurrancy(){
        
        if let currancy = getFromLocal("id_currancy") as? String {
            
            ModaManager.shared.currancy = currancy

        } else {
            
            ModaManager.shared.currancy = kCurrancyDefault

            saveInLocal("id_currancy", kCurrancyDefault)

        }
    }
    
    class func getCurrentLanguage(){
        
        let currntLang = Locale.current.languageCode
        
        if let lang = getFromLocal("id_language") as? String {
            
            if currntLang == lang {
                
                return
            }
            
            if lang == "default" {
                
                if currntLang != nil {
                   
                    saveLang(currntLang!)
                    
                } else {
                    
                    saveLang(kLanguangeDefault)

                }
                
            } else {
                
                saveLang(lang)

            }
            
        } else {

            saveLang(kLanguangeDefault)

        }

    }
    
    class func setVersionAndBuildNumber() {
        
        saveInLocal("version_preference", fullVersionOfApp())
 
    }
    
    class func isCardLiveMode() -> Bool{
        
        if let card_is_live_mode = getFromLocal("card_live_is_on") as? Bool {
            return card_is_live_mode
        }
        
        return !DEBUG_payment
 
    }
}
