//
//  ASONBaseSampleViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/7/18.
//  Copyright © 2018 ason. All rights reserved.
//
import UIKit
import SkyFloatingLabelTextField

class BaseViewController: UIViewController {
    
    private var blurredNetworkNotificationView: UIVisualEffectView!
    private var isNotified: Bool?
    private var blurredLoader: UIVisualEffectView!
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setColorsOnVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        onClearMemoryIfWarning()
    }
  
    
    func addLightLoader() {

        addBlurredLoader(with: 0, blurrIntensetive: 0.5)
    }
    
    
    func addBlurredLoader(with height: CGFloat = 0, blurrIntensetive : Float = 1) {
        print(height)
       
        if blurredLoader != nil {
            blurredLoader.removeFromSuperview()
            spinner.stopAnimating()
        }
        
        blurredLoader = UIVisualEffectView(effect: blurEffect)
        blurredLoader.layer.opacity = blurrIntensetive
//        blurredLoader.frame = UIScreen.main.bounds
//        blurredLoader.frame.size.height -= height
        
        //view.addSubview(blurredLoader)
        blurredLoader.frame = view.frame
        spinner.color = kColor_Black
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: blurredLoader.center.x, y: blurredLoader.center.y)
        
        blurredLoader.contentView.addSubview(spinner)
        
        view.addSubview(blurredLoader)
        spinner.startAnimating()
    }
    
    func removeBlurredLoader() {
        
        guard blurredLoader != nil else {  return  }
        
        spinner.stopAnimating()
        
        UIView.animate(
            withDuration: 0.3,
            animations: { self.blurredLoader.alpha = 0.0 },
            completion: { (value: Bool) in
                self.blurredLoader.removeFromSuperview()
        }
        )
    }
    
    
    func showAlertFromNet(_ error : String) {
        
        removeBlurredLoader()
        
        showAlert(error)
    }
    
    func showAlertFromNet(_ code: Int, _ error : String) {
        
        removeBlurredLoader()
        showAlertFromNet(error)
    }
    
    
    func setPropertiesOnTextFields(_ fields :  [SkyFloatingLabelTextField] ){

        fields.forEach {
            $0.tintColor = kColor_Black
            $0.textColor = kColor_AppDarkViolet
            $0.lineColor = kColor_Black
            $0.selectedTitleColor = kColor_Black
            $0.selectedLineColor = kColor_Black
            $0.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        }
    }
    
    @objc func textChanged(textField: UITextField) {

    }
    


}


class ASONBaseSampleViewControllerWithSorting : BaseViewController {
    
    @IBOutlet var sort: UIButton!
    
    
    @IBAction func changeSortType(_ sender: UIButton) {
        present(alertForSorting, animated: true, completion: nil)
    }
    
    
    func createAction(_ title : String) -> UIAlertAction{
        
        return  UIAlertAction(title: TR(title), style: .default) { action in
            self.sort.setTitle(TR("sort_catalogue") + ": " + TR(title), for: .normal)
            self.alertForSorting.actions.forEach {
                $0.isEnabled = true
                $0.setValue(kColor_Black, forKey: "titleTextColor")
            }
            action.isEnabled = false
            action.setValue(kColor_LightGray, forKey: "titleTextColor")
        }
        
    }
    
    
    lazy var alertForSorting: UIAlertController = {
        
        let alert = UIAlertController(title: kEmpty, message:  TR("sort_catalogue"), preferredStyle: .actionSheet)
        
//        let action0 = createAction(sortingVariants[0])
//        action0.isEnabled = false
//        action0.setValue(UIColor.lightGray, forKey: "titleTextColor")
//        alert.addAction(action0)
        
        sortingVariants.forEach { self.alertForSorting.addAction(createAction($0)) }
        
        let cancel = UIAlertAction(title: TR("cancel"), style: .cancel, handler: nil)
        alert.view.tintColor = kColor_Black
        alert.addAction(cancel)
        
        
        return alert
    }()
}


    
