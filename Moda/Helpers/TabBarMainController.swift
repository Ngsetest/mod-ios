//
//  TabBarMainController.swift
//  Moda
//
//  Created by Alimov Islom on 7/5/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

//extension UITabBar {
//    
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 60
//        return sizeThatFits
//    }
//}

class TabBarMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 0
        self.tabBar.tintColor = .black

        setColorsOnVC()
        
        setNamesOfTabs()
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func reloadTranslations() {
        
        setNamesOfTabs()
        
        for ind in 0..<5 {
            self.viewControllers?[ind].reloadTranslations()
            self.viewControllers?[ind].childViewControllers.forEach({ vc in
                if vc.isViewLoaded {
                    vc.reloadTranslations()
                }
            })

        }
    }
    
    func setNamesOfTabs(){
        for ind in 0..<5 {
            self.viewControllers?[ind].title = TR(nameOfMainTabs[ind])
        }
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue){
        
        
    }

}
