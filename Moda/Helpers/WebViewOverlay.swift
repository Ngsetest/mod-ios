//
//  WebViewOverlay.swift
//  Moda
//
//  Created by admin_user on 5/5/19.
//  Copyright © 2019 moda. All rights reserved.
//

import UIKit
import WebKit

class WebViewOverlay: BaseViewController{
    
    var path           : String?
    var pathHTML       : String?
    var heightShift    : CGFloat = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let frame = CGRect(origin: CGPoint(x: 0, y: heightShift),
                           size: CGSize(width: self.view.frame.width,
                                        height: self.view.frame.height - heightShift))
        
        if #available(iOS 11, *) {

            let webView = WKWebView(frame: frame)
            webView.navigationDelegate = self
            
            if pathHTML != nil {
                webView.loadHTMLString(pathHTML!, baseURL: nil)
            } else {
                let url = URL(string: path!)
                let request = URLRequest(url: url!)
                webView.load(request)
            }
            view.addSubview(webView)

        } else {

            let webView = UIWebView(frame:frame)
            webView.delegate = self
            
            if pathHTML != nil {
                webView.loadHTMLString(pathHTML!, baseURL: nil)
            } else {
                let url = URL(string: path!)
                let request = URLRequest(url: url!)
                webView.loadRequest(request)
            }
            view.addSubview(webView)
 
        }
        
        

    }
    
    @IBAction func onExit(){
        
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension WebViewOverlay: UIWebViewDelegate{
 
    
    func webViewDidStartLoad(_ webView: UIWebView){
        addBlurredLoader()

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        removeBlurredLoader()

    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
        removeBlurredLoader()

    }
    
}



extension WebViewOverlay: WKNavigationDelegate{

    //MARK: - Delegate
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        addBlurredLoader()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        removeBlurredLoader()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        removeBlurredLoader()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        removeBlurredLoader()
        
    }

}
