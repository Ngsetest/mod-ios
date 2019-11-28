//
//  UIViewController+Extension.swift
//  Moda
//
//  Created by Alimov Islom on 8/9/18.
//  Copyright © 2018 moda. All rights reserved.
//
import UIKit

extension UIViewController {

    func setNamesForGenderSelection(_ gSelect : UISegmentedControl ){
        
        for ind in 0..<namesOfGenderTabs.count {
            gSelect.setTitle(TR(namesOfGenderTabs[ind]).uppercased(), forSegmentAt: ind)
        }
    }
    
    
    func showOverLayer(_ vcOverlay : UIViewController, fromParentVC : UIViewController? = nil){
        
        vcOverlay.modalPresentationStyle = .overCurrentContext
        
        let vcFrom = fromParentVC == nil ? self : fromParentVC!
        
        if self.tabBarController != nil {
            vcFrom.tabBarController?.present(vcOverlay, animated: true, completion: nil)
        } else {
            vcFrom.navigationController?.present(vcOverlay, animated: true, completion: nil)
        }
    }
    
    
    func showVC(_ vc : UIViewController, fromParentVC : UIViewController? = nil){
        
        clearBackButton()

        let vcFrom = fromParentVC == nil ? self : fromParentVC!
        
        vcFrom.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func setVC(_ name : String){
        
        let newVC = getVCFromMain(name)
        
        navigationController?.setViewControllers([ newVC ], animated: false)
        
    }
    
    func clearBackButton(_ fromParentVC : UIViewController? = nil){
        
        let vcFrom = fromParentVC == nil ? self : fromParentVC!
        
        vcFrom.parent?.navigationItem.backBarButtonItem?.title = kEmpty
        vcFrom.navigationController?.navigationItem.backBarButtonItem?.title = kEmpty
        vcFrom.tabBarController?.navigationItem.backBarButtonItem?.title = kEmpty
    }
    
    @objc func askForLogout() {

    }
    
    func showVCFromName(_ name : String, funcPreInit: vcPreInitClosure? = nil, isOverLayer : Bool = false, fromParentVC : UIViewController? = nil){
        
        var vc = getVCFromMain(name)
        
        funcPreInit?(&vc)
        
        if isOverLayer {
            
            showOverLayer(vc)
            
        } else {
            
            showVC(vc)
        }
 
    }

    
    func showAlert(_ line: String?,  title : String? = nil, okLine : String? = "ok", noLine : String? = nil, handlerOnNO : (() -> Void)? = nil, handlerOnOK : (() -> Void)? = nil ) {
        
        if line == nil {
            return
        }
        
        let alertViewTmp = UIAlertController(title: line, message: kEmpty, preferredStyle: .alert)
        
        if okLine != nil {
            
            let defaultAction = UIAlertAction(title: TR(okLine), style: .default) { (actionAlert : UIAlertAction) in
                handlerOnOK?()
            }
            alertViewTmp.addAction(defaultAction)
            
        }
 
        if noLine != nil {
            
            let noAction = UIAlertAction(title: TR(noLine), style: .default) { (actionAlert : UIAlertAction) in
                handlerOnNO?()
            }
            alertViewTmp.addAction(noAction)

        }

        present(alertViewTmp, animated: true, completion:nil)
    }
    
}
