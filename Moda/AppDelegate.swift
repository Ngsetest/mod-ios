//
//  AppDelegate.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/23/18.
//  Copyright © 2018 moda. All rights reserved.
//

import GooglePlacePicker
import GooglePlaces
import IQKeyboardManagerSwift
import UIKit
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    weak var blurredNetworkNotificationView: UIVisualEffectView?
    private var isNotified: Bool?
    
    private func printAllFontFamilies() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        printAllFontFamilies()
//        
//        print("records = ", records)
//
//        print("topTenAlbums = ", topAlbums)
        
        
        SettingsBundleHelper.updateAfterEnterApp()

        GMSPlacesClient.provideAPIKey(kGoogleKey)
 
        IQKeyboardManagerSettings()

        searchBarCustomize()
        
        navigationBarSettings()
        
        windowsSettings()
 
        let versionName = ModaManager.shared.getCurrentVersionInfo()
        if versionName != kEmpty {
            
            debugPrint(title:"versionName", versionName)
        }
        
        ModaManager.shared.setVersionInfo(info: fullVersionOfApp())

        
        if  ModaManager.shared.getModaNotificationReminder() == nil {
            
            window?.rootViewController = getVCFromMain("SelectLanguageVC")


        } else {
            
            window?.rootViewController = getVCFromMain()

        }
 
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    
 
    //MARK: - SETTINGS

    func windowsSettings(){
        
        window?.tintColor = kColor_Black
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
    }
    
    func IQKeyboardManagerSettings(){
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = TR("ready").uppercased()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 150.0
    }

    func navigationBarSettings() {
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: kColor_Black,
            NSAttributedStringKey.font: UIFont(name: kFont_medium, size: 16)!
        ]
       
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = kColor_White
        
        let attrsBackButton = [
            NSAttributedStringKey.foregroundColor: kColor_No
        ]
 
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes(attrsBackButton, for: .normal)
        BarButtonItemAppearance.setTitleTextAttributes(attrsBackButton, for: .highlighted)
        
        
    }

    //MARK: - NOTIFICATIONS
    
    
//        func registerForPushNotifications(application: UIApplication) {
//            let notificationSettings = UIUserNotificationSettings(forTypes: [.alert, .sound, .alert], categories: nil)
//            application.registerUserNotificationSettings(notificationSettings)
//        }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 
        debugLog("didFailToRegisterForRemoteNotificationsWithError = " + error.localizedDescription)

    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = getIdForAppNotificstions(deviceToken)
       
        //ModaManager.shared.setModaNotificationReminer(token)

    }
  
    func attempRegisterForNotifications(_ application: UIApplication){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
        { (success, error) in
            if success {
                
                debugLog("Permission Granted")
                
            } else {
                
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus != .authorized {
                        
                        debugLog("User has not authorized notifications")
                    }
                    if settings.lockScreenSetting != .enabled {
                        //ModaManager.shared.setModaNotificationReminer(kEmpty)
                        debugLog("User has either disabled notifications on the lock screen for this app or it is not supported")
                    }
                })
            }
        }
        
        application.registerForRemoteNotifications()
        
    }

    //MARK: - application stuff
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        //  or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        //  and store enough application state information to restore your application to its current state
        //  in case it is terminated later.
        // If your application supports background execution, this method is called instead of
        //  applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the
        //  changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.

        if !firstEnterSession {
            SettingsBundleHelper.updateAfterAwakeApp()
        }
        
        firstEnterSession = false
 
        updateUserInterface()
        
        window?.layer.cornerRadius = 5
        window?.clipsToBounds = true
        window?.isOpaque = true
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Global customize
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

    @objc func updateUserInterface() {
        
        guard let status = Network.reachability?.status else {
            if blurredNetworkNotificationView != nil {
                removeBlurredNetworkNotificationView()
            }
            return
        }

        if case .unreachable = status {
            if isNotified == nil || isNotified == false {
                addBlurredNetworkNotificationView()
                isNotified = true
            }
        } else if isNotified != nil || isNotified == true {
            removeBlurredNetworkNotificationView()
            isNotified = false
        }
    }

    private func addBlurredNetworkNotificationView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = UIScreen.main.bounds
        window!.addSubview(blurView)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = UIScreen.main.bounds

        let vibrantLabel = UILabel()
        vibrantLabel.text = TR("error_connection")
        vibrantLabel.font = UIFont(name: kFont_bold, size: 21)!
        vibrantLabel.textColor = kColor_Black.withAlphaComponent(0.7)
        vibrantLabel.numberOfLines = 0
        vibrantLabel.textAlignment = .center
        vibrantLabel.sizeToFit()
        vibrantLabel.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
        vibrantLabel.translatesAutoresizingMaskIntoConstraints = false
        vibrancyEffectView.contentView.addSubview(vibrantLabel)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                vibrantLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(vibrancyEffectView.leadingAnchor, multiplier: 2),
                vibrantLabel.trailingAnchor.constraint(equalTo: vibrancyEffectView.trailingAnchor, constant: -16),
                vibrantLabel.centerYAnchor.constraint(equalTo: vibrancyEffectView.centerYAnchor)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                vibrantLabel.trailingAnchor.constraint(equalTo: vibrancyEffectView.trailingAnchor, constant: -16),
                vibrantLabel.centerYAnchor.constraint(equalTo: vibrancyEffectView.centerYAnchor)
                ])
        }

        blurView.contentView.addSubview(vibrancyEffectView)
        blurredNetworkNotificationView = blurView
    }

    private func removeBlurredNetworkNotificationView() {
        blurredNetworkNotificationView?.removeFromSuperview()
    }
 
    // MARK: - Read and Write

    func write(text: String, to fileNamed: String, folder: String) {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else {
            return
        }

        if !fileExist(path: writePath.absoluteString) {
            try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        }

        let file = writePath.appendingPathComponent(fileNamed + ".json")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    

    func read(from fileNamed: String, folder: String) -> String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        guard let readPath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else {
            return nil
        }

        if !fileExist(path: readPath.absoluteString) {
            try? FileManager.default.createDirectory(atPath: readPath.path, withIntermediateDirectories: true)
        }

        let file = readPath.appendingPathComponent(fileNamed + ".json")
        return try? String(contentsOf: file)
    }

    func fileExist(path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let fm = FileManager.default
        return fm.fileExists(atPath: path, isDirectory: &isDirectory)
    }
}



