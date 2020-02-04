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
    
    @IBOutlet var likeStackView: UIStackView!
    @IBOutlet var shareStackView: UIStackView!
    @IBOutlet var rateStackView: UIStackView!
    
    @IBOutlet var xenoCantoButton: UIButton!
    @IBOutlet var authorsButton: UIButton!
    @IBOutlet var videosButton: UIButton!
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    let bag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
        let backButton = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
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

        likeStackView.addGestureRecognizer(likeTap)
        shareStackView.addGestureRecognizer(shareTap)
        rateStackView.addGestureRecognizer(rateTap)
                
        likeTap.rx.event
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://www.facebook.com/pticenadlanu/") else { return }
                    UIApplication.shared.open(url)
                }
            }).disposed(by: bag)
        
        shareTap.rx.event
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.shareAppLink()
                }
            }).disposed(by: bag)
        
        rateTap.rx.event
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview()
                }
            }).disposed(by: bag)
        
        xenoCantoButton.rx.tap
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://www.xeno-canto.org/") else { return }
                    UIApplication.shared.open(url)
                }
            }).disposed(by: bag)
        
        authorsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.authorsButtonPressed()
            }).disposed(by: bag)
        
        videosButton.rx.tap
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://www.youtube.com/user/Kenza432/videos") else { return }
                    UIApplication.shared.open(url)
                }
            }).disposed(by: bag)
    }
    
    fileprivate func shareAppLink() {
        let appleID = "1483736814"
        let appText = "Preuzmite aplikaciju Ptice na dlanu"
        
        if let appLink = URL(string: "https://itunes.apple.com/us/app/myapp/id\(appleID)?ls=1&mt=8"), !appLink.absoluteString.isEmpty {
            
            let activityViewController = UIActivityViewController(activityItems: [appLink, appText], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = shareLabel
            activityViewController.popoverPresentationController?.sourceRect = shareLabel.frame
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
