//
//  DynamicView.swift
//  WebViewWrapper
//
//  Created by Dean Chang on 12/13/18.
//  Copyright © 2018 Freestar. All rights reserved.
//

import UIKit
import WebKit

@objc public protocol DynamicWebViewDelegate: class {
    @objc func webViewDidFinishedLoading(view: DynamicWebView)
    @objc func webViewDidFailToLoad(view: DynamicWebView, error: Error)
}

final public class DynamicWebView: UIView {
    
    public weak var delegate: DynamicWebViewDelegate?
        
    @available(iOS 8.0, *)
    fileprivate lazy var wkWebView: WKWebView  = {
        var webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
//        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    var webBackgroundColor: UIColor? {
        didSet{
            if let webBackgroundColor = webBackgroundColor {
                self.wkWebView.backgroundColor = webBackgroundColor
                self.wkWebView.scrollView.backgroundColor = webBackgroundColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
    }
    
    public func setupView() {
        self.addSubview(self.wkWebView)
        self.wkWebView.translatesAutoresizingMaskIntoConstraints = false
        self.wkWebView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.wkWebView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.wkWebView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.wkWebView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    public func loadHTML(_ string: String) {
        self.wkWebView.loadHTMLString(string, baseURL: nil)
    }
    
    public func loadRequest(_ urlRequest: URLRequest) {
        self.setupView()
        self.wkWebView.load(urlRequest)
    }
    
    public func evaluateJS(script: String, result: @escaping (String) -> Void) {
        self.wkWebView.evaluateJavaScript(script) { (response, error) in
            if let error = error {
                print(error)
            } else {
                if let response  = response {
                    print(response)
                }
            }
        }
    }
}

@available(iOS 8.0, *)
extension DynamicWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let delegate = self.delegate {
            delegate.webViewDidFinishedLoading(view: self)
        }
        
        
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            print(html!)
        })
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let delegate = self.delegate {
            delegate.webViewDidFailToLoad(view: self, error: error)
        }
    }
}



