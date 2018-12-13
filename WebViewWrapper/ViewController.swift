//
//  ViewController.swift
//  WebViewWrapper
//
//  Created by Dean Chang on 12/13/18.
//  Copyright © 2018 Freestar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DynamicWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        
        //        webView.loadHTML("")
        webView.loadRequest(URLRequest(url: URL(string: "https://google.com")!))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate lazy var webView: DynamicWebView  = {
        var webView = DynamicWebView(frame: view.frame)
        webView.delegate = self
        webView.useLegacyWebView = true // use UIWebView
        return webView
    }()
    
    func webViewDidFinishedLoading(view: DynamicWebView) {
        print("success")
    }
    
    func webViewDidFailToLoad(view: DynamicWebView, error: Error) {
        print("failure: \(error)")
    }
}

