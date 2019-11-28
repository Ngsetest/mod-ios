//
//  HalfModalPresentationController.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    var isMaximized: Bool = false
    
    func adjustToFullScreen() {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                
                if let navController = self.presentedViewController as? UINavigationController {
                    self.isMaximized = true
                    
                    // Force the navigation bar to update its size
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let shift = getUpperShiftFromAnyScreen()
        return CGRect(
            x: 0,
            y: shift,
            width: containerView!.bounds.width,
            height: UIScreen.main.bounds.height - shift
        )
    }
    
    override func presentationTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) -> Void in
                // self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.presentedView?.endEditing(true)
                // self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.isMaximized = false
        } else {
            self.presentedView?.endEditing(true)
        }
    }
}

protocol HalfModalPresentable {}

extension HalfModalPresentable where Self: UIViewController {
    func maximizeToFullScreen() {
        if let presetation = navigationController?.presentationController as? HalfModalPresentationController {
            presetation.adjustToFullScreen()
        }
    }
}

