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
    
    
    func loadWebView() {
        webView.loadHTML("<div align=\"center\" id=\"nextshark_mrec_smartnews\">\n        <script data-cfasync=\"false\" type=\"text/javascript\">\n            var freestar = freestar || {};\n            freestar.queue = freestar.queue || [];\n            freestar.config = freestar.config || {};\n            freestar.config.enabled_slots = [];\n            freestar.initCallback = function () {\n                (freestar.config.enabled_slots.length === 0) ? freestar.initCallbackCalled = false: freestar\n                    .newAdSlots(freestar.config.enabled_slots)\n            }\n            freestar.config.disabledProducts = {\n                stickyFooter: true,\n                googleInterstitial: true\n            }\n            freestar.queue.push(function () {\n                googletag.pubads().set('page_url', 'https://www.nextshark.com/');\n                freestar.newAdSlots({\n                    placementName: \"nextshark_mrec_smartnews\",\n                    slotId: \"nextshark_mrec_smartnews\"\n                });\n            });\n        </script>\n        <script src=\"https://a.pub.network/nextshark-com/pubfig.min.js\" async></script>\n    </div>")
        
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

