//
//  ASONBaseSampleTableViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/15/18.
//  Copyright © 2018 ason. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    private var blurredNetworkNotificationView: UIVisualEffectView!
    private var isNotified: Bool?
    private var blurredLoader: UIVisualEffectView!
    
    
    
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

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        blurredLoader = UIVisualEffectView(effect: blurEffect)
        blurredLoader.frame = UIScreen.main.bounds
        blurredLoader.frame.size.height -= height
        blurredLoader.layer.opacity = blurrIntensetive

        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.color = kColor_Black
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: blurredLoader.center.x, y: blurredLoader.center.y)
        
        blurredLoader.contentView.addSubview(spinner)
        
        view.addSubview(blurredLoader)
        spinner.startAnimating()
    }
    
    func removeBlurredLoader() {
        blurredLoader.contentView.subviews.forEach {
            if let spinner = $0 as? UIActivityIndicatorView {
                spinner.stopAnimating()
            }
        }
        
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
    
}
