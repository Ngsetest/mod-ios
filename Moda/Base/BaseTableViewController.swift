//
//  BaseTableViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/15/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    weak var blurredLoader: UIVisualEffectView?
    
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

        let loader = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.prominent))
        loader.frame = UIScreen.main.bounds
        loader.frame.size.height -= height
        loader.layer.opacity = blurrIntensetive

        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.color = kColor_Black
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: loader.center.x, y: loader.center.y)
        
        loader.contentView.addSubview(spinner)
        
        view.addSubview(loader)
        spinner.startAnimating()
        
        blurredLoader = loader
    }
    
    func removeBlurredLoader() {
        blurredLoader?.contentView.subviews.forEach {
            if let spinner = $0 as? UIActivityIndicatorView {
                spinner.stopAnimating()
            }
        }
        
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
        
        removeBlurredLoader()
        showAlertFromNet(error)
    }
    
}
