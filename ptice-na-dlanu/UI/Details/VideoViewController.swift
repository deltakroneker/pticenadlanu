//
//  VideoViewController.swift
//  ptice-na-dlanu
//
//  Created by Jelena on 17/10/2019.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var indicatorLabel: UILabel!
    
    // MARK: - Vars & lets
    weak var coordinator: AppCoordinator?
    var videoURL = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let myURL = URL.init(string: videoURL + "?rel=0")!
        let myURLRequest = URLRequest.init(url: myURL)
        myWebView.navigationDelegate = self
        
        myWebView.load(myURLRequest)
    }
}

// TODO: empty states design

// MARK: - WKNavigationDelegate

extension VideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorLabel.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicatorLabel.text = "proverite konekciju i pokušajte kasnije..."
        indicatorLabel.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        indicatorLabel.text = "proverite konekciju i pokušajte kasnije..."
        indicatorLabel.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorLabel.text = "Video se učitava..."
        indicatorLabel.isHidden = false
    }
}
