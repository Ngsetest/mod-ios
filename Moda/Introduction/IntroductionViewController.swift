//
//  IntroductionViewController.swift
//  Moda
//
//  Created by Alimov Islom on 8/8/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class IntroductionViewController: UIPageViewController {
 
    let pageController: UIPageControl = {
        let pageController = UIPageControl()
        pageController.numberOfPages = 4
        pageController.pageIndicatorTintColor = kColor_AppBlack
        pageController.currentPageIndicatorTintColor = kColor_AppOrange
        pageController.translatesAutoresizingMaskIntoConstraints = false
        return pageController
    }()
    
    private lazy var pages: [UIViewController] = {
        return [
            self.getViewOneController(0),
            self.getViewOneController(1),
            self.getViewOneController(2),
            self.getNotificationViewController()
        ]
    }()
    
    //MARK: - View Controller

     override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate   = self
        
        view.backgroundColor = kColor_White
        
        if let viewController = pages.first {
            setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        reloadTranslations()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        ModaManager.shared.setModaInroduced()

        super.viewWillDisappear(animated)
        
    }
    
    func setupUI(){
        
        self.view.addSubview(skipButton)
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        skipButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        
        self.view.addSubview(pageController)
        pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -43).isActive = true
        pageController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        pageController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
    }

    //MARK: - private stuff
 
    override func reloadTranslations() {
        
        skipButton.setTitle(TR("pass"), for: .normal)
        pages.forEach { vc in
            (vc as? BaseViewController)?.reloadTranslations()
        }
    }
    
    private func getViewOneController(_ tag: Int) -> UIViewController
    {
        let vc = getVCFromMain("IntroductionOneViewController")
        vc.view.tag = tag
        return vc
    }

    private func getNotificationViewController() -> UIViewController
    {
        let vc = getVCFromMain("NotificationViewController")
        vc.view.tag = 3
        return vc
    }

    private let skipButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.tintColor = kColor_Black
        button.titleLabel?.font = UIFont.init(name: kFont_normal, size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Actions
    
    @objc  private func handleSkipButton() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
         
        let viewController = pages.last
        viewController?.view.frame = rootViewController.view.frame
        viewController?.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    
}
// MARK: UIPageViewControllerDataSource

extension IntroductionViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil } // pages.last
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil } //pages.first
        
        guard pages.count > nextIndex else { return nil  }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        let tag = pageViewController.viewControllers!.first!.view.tag
        if tag == (pages.count - 1) {
            self.skipButton.fadeOut()
            self.pageController.fadeOut()
            
        }
        else {
            let hiddenFlag = skipButton.isHidden
            if hiddenFlag {
                self.skipButton.fadeIn()
                self.pageController.fadeIn()
            }
        }
        self.pageController.currentPage = pageViewController.viewControllers!.first!.view.tag
    }
}

extension IntroductionViewController: UIPageViewControllerDelegate {
}


