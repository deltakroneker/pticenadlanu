//
//  VideoViewController.swift
//  ptice-na-dlanu
//
//  Created by Jelena on 17/10/2019.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {

    @IBOutlet var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let myURL = URL.init(string: "https://www.youtube.com/embed/kmhDEns3lzs")!
        let myURLRequest = URLRequest.init(url: myURL)
        myWebView.load(myURLRequest)
    }
}
