//
//  Extensions.swift
//  ptice-na-dlanu
//
//  Created by Jelena Krmar on 06/04/2020.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

extension UIViewController {
    func shareApp(message: String, sourceView: UIView? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let appleID = "1483736814"
            
            if let appLink = URL(string: "https://itunes.apple.com/us/app/myapp/id\(appleID)?ls=1&mt=8"), !appLink.absoluteString.isEmpty {
                
                let activityViewController = UIActivityViewController(activityItems: [appLink, message], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = sourceView ?? self.view
                activityViewController.popoverPresentationController?.sourceRect = sourceView?.frame ?? CGRect.init(x: self.view.frame.midX - 1, y: self.view.frame.midY - 1, width: 2, height: 2)
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
