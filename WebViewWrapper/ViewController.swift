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
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.webView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.setupView()
        
        loadWebView()
        delay(15.0) {
            self.loadWebView()
        }
        delay(30.0) {
            self.loadWebView()
        }
        delay(45.0) {
            self.loadWebView()
        }
        delay(60.0) {
            self.loadWebView()
        }
        delay(75.0) {
            self.loadWebView()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func htmlFromTagFile() -> String? {
        guard let filePath = Bundle.main.path(forResource: "adtag", ofType: "html") else {
           print ("File reading error")
           return nil
        }

        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            return contents
        } catch {
            print ("File HTML error")
        }
        return nil
    }
    
    
    func loadWebView() {
        let html = self.htmlFromTagFile()
        guard let html = html else {
            return
        }
        webView.loadHTML(html)
        
//                webView.loadRequest(URLRequest(url: URL(string: "https://google.com")!))
    }
    
    fileprivate lazy var webView: DynamicWebView  = {
        var webView = DynamicWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        webView.backgroundColor = UIColor.cyan
        webView.delegate = self        
        return webView
    }()
    
    func webViewDidFinishedLoading(view: DynamicWebView) {
        print("success")
    }
    
    func webViewDidFailToLoad(view: DynamicWebView, error: Error) {
        print("failure: \(error)")
    }
}

