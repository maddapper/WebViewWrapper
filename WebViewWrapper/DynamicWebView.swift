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
    
    var useLegacyWebView: Bool?
    
    fileprivate lazy var uiWebView: UIWebView  = {
        var webView = UIWebView(frame: self.frame)
        webView.delegate = self
        webView.backgroundColor = UIColor.gray
//        webView.scrollView.isScrollEnabled = false        
        return webView
    }()
    
    @available(iOS 8.0, *)
    fileprivate lazy var wkWebView: WKWebView  = {
        var webView = WKWebView(frame: self.frame)
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
//        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    var webBackgroundColor: UIColor? {
        didSet{
            if let webBackgroundColor = webBackgroundColor {
                if useLegacyWebView! {
                    self.uiWebView.backgroundColor = webBackgroundColor
                    self.uiWebView.scrollView.backgroundColor = webBackgroundColor
                } else {
                    self.wkWebView.backgroundColor = webBackgroundColor
                    self.wkWebView.scrollView.backgroundColor = webBackgroundColor
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        useLegacyWebView = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        useLegacyWebView = false
    }
    
    fileprivate func setupView() {
        if useLegacyWebView! {
            self.addSubview(self.uiWebView)
            self.uiWebView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: self.uiWebView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.uiWebView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: self.uiWebView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: self.uiWebView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
            self.addConstraints([horizontalConstraint, verticalConstraint, leftConstraint, rightConstraint])
        } else {
            self.addSubview(self.wkWebView)
            self.wkWebView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: self.wkWebView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.wkWebView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: self.wkWebView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: self.wkWebView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
            self.addConstraints([horizontalConstraint, verticalConstraint, leftConstraint, rightConstraint])
            
        }
    }
    
    public func loadHTML(_ string: String) {
        if useLegacyWebView! {
            self.uiWebView.loadHTMLString(string, baseURL: nil)
        } else {
            self.wkWebView.loadHTMLString(string, baseURL: nil)
        }
    }
    
    public func loadRequest(_ urlRequest: URLRequest) {
        self.setupView()
        if useLegacyWebView! {
            self.uiWebView.loadRequest(urlRequest)
        } else {
            self.wkWebView.load(urlRequest)
        }
    }
    
    public func evaluateJS(script: String, result: @escaping (String) -> Void) {
        if useLegacyWebView! {
            result(self.uiWebView.stringByEvaluatingJavaScript(from: script) ?? "")
        } else {
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
}

extension DynamicWebView: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if let delegate = self.delegate {
            delegate.webViewDidFinishedLoading(view: self)
        }
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if let delegate = self.delegate {
            delegate.webViewDidFailToLoad(view: self, error: error)
        }
    }
}

@available(iOS 8.0, *)
extension DynamicWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let delegate = self.delegate {
            delegate.webViewDidFinishedLoading(view: self)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let delegate = self.delegate {
            delegate.webViewDidFailToLoad(view: self, error: error)
        }
    }
}



