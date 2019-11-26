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
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var videoIcon: UIImageView!
    @IBOutlet var lineIcon: UIImageView!
    @IBOutlet var replayButton: UIBarButtonItem!
    
    // MARK: - Vars & lets
    weak var coordinator: AppCoordinator?
    var videoURL = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialEmptyState()
                
        let myURL = URL.init(string: videoURL + "?rel=0")!
        let myURLRequest = URLRequest.init(url: myURL)
        myWebView.navigationDelegate = self
        
        myWebView.load(myURLRequest)
    }
    
    // MARK: - Helpers
    
    fileprivate func setupInitialEmptyState() {
        indicatorLabel.text = "Video se učitava..."
        indicatorLabel.isHidden = false
        detailsLabel.isHidden = true
        videoIcon.image = videoIcon.image?.withRenderingMode(.alwaysTemplate)
        videoIcon.tintColor = UIColor(named: "darkGray")
        videoIcon.isHidden = false
        lineIcon.isHidden = true
        replayButton.isEnabled = false
        myWebView.isHidden = true
    }
    
    fileprivate func setupErrorState() {
        indicatorLabel.text = "Video nije moguće učitati"
        indicatorLabel.isHidden = false
        detailsLabel.isHidden = false
        videoIcon.image = videoIcon.image?.withRenderingMode(.alwaysTemplate)
        videoIcon.tintColor = UIColor(named: "darkGray")
        videoIcon.isHidden = false
        lineIcon.isHidden = false
        replayButton.isEnabled = true
        myWebView.isHidden = true
    }
    
    fileprivate func setUpSuccessState() {
        indicatorLabel.isHidden = true
        detailsLabel.isHidden = true
        videoIcon.isHidden = true
        lineIcon.isHidden = true
        replayButton.isEnabled = true
        myWebView.isHidden = false
    }
    
    @IBAction func replayTapped(_ sender: UIBarButtonItem) {
        replayButton.isEnabled = false
        myWebView.reload()
    }
}

// MARK: - WKNavigationDelegate

extension VideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setUpSuccessState()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        setupErrorState()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        setupErrorState()
    }
}
