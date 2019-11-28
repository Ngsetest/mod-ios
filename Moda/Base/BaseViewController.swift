//
//  BaseViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/7/18.
//  Copyright © 2018 moda. All rights reserved.
//
import UIKit
import SkyFloatingLabelTextField

class BaseViewController: UIViewController {
    
    
    weak var blurredLoader: UIVisualEffectView?
    weak var spinner : UIActivityIndicatorView?
  
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
        debugLog(height)
       
        if blurredLoader != nil {
            spinner?.stopAnimating()
            blurredLoader?.removeFromSuperview()
            blurredLoader = nil
        }
        
        let loader = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.prominent))
        loader.layer.opacity = blurrIntensetive
//       loader.frame = UIScreen.main.bounds
//       loader.frame.size.height -= height
//        
        
         let spinnerWheel = UIActivityIndicatorView(activityIndicatorStyle: .white)
        //view.addSubview(blurredLoader)
        loader.frame = view.frame
        spinnerWheel.color = kColor_Black
        spinnerWheel.hidesWhenStopped = true
        spinnerWheel.center = CGPoint(x: loader.center.x, y: loader.center.y)
        
        loader.contentView.addSubview(spinnerWheel)
        
        view.addSubview(loader)
        spinnerWheel.startAnimating()
        
        blurredLoader = loader
        spinner = spinnerWheel
        
    }
    
    func removeBlurredLoader() {
        
        guard blurredLoader != nil else {  return  }
        
        spinner?.stopAnimating()
        
        UIView.animate(
            withDuration: 0.3,
            animations: { self.blurredLoader?.alpha = 0.0 },
            completion: { (value: Bool) in
                self.blurredLoader?.removeFromSuperview()
        }
        )
    }
    
    
    func showAlertFromNet(_ error : String) {
        
        removeBlurredLoader()
        showAlert(error)
    }
    
    func showAlertFromNet(_ code: Int, _ error : String) {
        
        if code == kErrorConnection  && !DEBUG_net_off{
            
            showAlert( error,   okLine: TR("Обновить"), noLine: nil, handlerOnNO: nil) {
                
                
                
            }

            
        } else {
            
            removeBlurredLoader()
            showAlert(error)
        }
        
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
    
    
    
    @IBAction func onSocialTap(_ button : UIButton){
        
        switch button.tag {
        case 10 :  openSocialPage(.viber)
        case 20 :  openSocialPage(.telegram)
        case 30 :  openSocialPage(.facebook)
        case 40 :  openSocialPage(.vk)
        case 50 :  openSocialPage(.ok)
        case 60 :  openSocialPage(.whatsapp)
            
        case 100 :  callPhone(supportPhoneNumber1)
        case 200 :  callPhone(supportPhoneNumber2)
        default : break
        }
        
    }

}


class BaseViewControllerWithSorting : BaseViewController {
    
    @IBOutlet weak var sort: UIButton!
    
    deinit {
        sort = nil
    }
    
    
    @IBAction func changeSortType(_ sender: UIButton) {
        
        present(alertForSorting, animated: true) {
            
        }
    }
    
    
    @objc func sortingWasChoosen(_ ind  : Int) {
        
    }
    
    func setSortText(_ title : String){
 
        sort.setTitle( TR(title), for: .normal)
    }
    
    func createAction(_ title : String, _ ind : Int) -> UIAlertAction{
        
        return  UIAlertAction(title: TR(title), style: .default) { action in
            self.setSortText(title)
            self.alertForSorting.actions.forEach {
                $0.isEnabled = true
                $0.setValue(kColor_Black, forKey: "titleTextColor")
            }

            action.isEnabled = false
            action.setValue(kColor_LightGray, forKey: "titleTextColor")
            
            self.sortingWasChoosen(ind)

        }
        
    }
    
    
    lazy var alertForSorting: UIAlertController = {
        
        let alert = UIAlertController(title: kEmpty, message:  TR("sort_catalogue").uppercased(), preferredStyle: .actionSheet)

        for i in 0..<sortingVariants.count {
             alert.addAction(createAction(sortingVariants[i],i))
        }
        
        let cancel = UIAlertAction(title: TR("cancel"), style: .cancel, handler: nil)
        alert.view.tintColor = kColor_Black
        alert.addAction(cancel)
        return alert
    }()
}


    
