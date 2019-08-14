//
//  AboutAppViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/29/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit
import FontAwesome_swift

class AboutAppViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var rateImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    let bag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    // MARK: - Methods

    fileprivate func setupController() {
        likeLabel.attributedText = NSAttributedString(string: "Lajkujte našu stranicu",
                                                      attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        shareLabel.attributedText = NSAttributedString(string: "Podelite s prijateljima",
                                                      attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        rateLabel.attributedText = NSAttributedString(string: "Ocenite nas na App Store",
                                                      attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        likeImageView.image = UIImage.fontAwesomeIcon(name: .thumbsUp,
                                                      style: .solid,
                                                      textColor: UIColor(named: "blue") ?? .blue,
                                                      size: CGSize(width: 100,height: 100))
        
        shareImageView.image = UIImage.fontAwesomeIcon(name: .shareAlt,
                                                       style: .solid,
                                                       textColor: UIColor(named: "colorAccent") ?? .brown,
                                                       size: CGSize(width: 100, height: 100))
        
        rateImageView.image = UIImage.fontAwesomeIcon(name: .star,
                                                      style: .solid,
                                                      textColor: UIColor(named: "colorPrimaryDark") ?? .green,
                                                      size: CGSize(width: 100, height: 100))
    }
    
    fileprivate func setupBindings() {
        let likeTap = UITapGestureRecognizer()
        let shareTap = UITapGestureRecognizer()
        let rateTap = UITapGestureRecognizer()

        likeLabel.addGestureRecognizer(likeTap)
        shareLabel.addGestureRecognizer(shareTap)
        rateLabel.addGestureRecognizer(rateTap)
                
        likeTap.rx.event
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://www.facebook.com/pticenadlanu/") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        shareTap.rx.event
            .subscribe(onNext: { _ in
                self.shareAppLink()
            }).disposed(by: bag)
        
        rateTap.rx.event
            .subscribe(onNext: { _ in
                SKStoreReviewController.requestReview()
            }).disposed(by: bag)
    }
    
    fileprivate func shareAppLink() {
        let text = "URL aplikacije"
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = shareLabel
        activityViewController.popoverPresentationController?.sourceRect = shareLabel.frame
        self.present(activityViewController, animated: true, completion: nil)
    }
}
