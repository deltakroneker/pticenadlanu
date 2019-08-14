//
//  AboutUsViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/29/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AboutUsViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
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
        posterLabel.attributedText = NSAttributedString(string: posterLabel.text ?? "",
                                                        attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        phoneLabel.attributedText = NSAttributedString(string: phoneLabel.text ?? "",
                                                       attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        websiteLabel.attributedText = NSAttributedString(string: websiteLabel.text ?? "",
                                                         attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        emailLabel.attributedText = NSAttributedString(string: emailLabel.text ?? "",
                                                       attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        markerImageView.image = UIImage.fontAwesomeIcon(name: .mapMarker, style: .solid,
                                                      textColor: .black, size: CGSize(width: 50,height: 50))
        
        phoneImageView.image = UIImage.fontAwesomeIcon(name: .phone, style: .solid,
                                                       textColor: .black, size: CGSize(width: 50, height: 50))
        
        emailImageView.image = UIImage.fontAwesomeIcon(name: .at, style: .solid,
                                                      textColor: .black, size: CGSize(width: 50, height: 50))
    }
    
    fileprivate func setupBindings() {
        let posterTap = UITapGestureRecognizer()
        let phoneTap = UITapGestureRecognizer()
        let websiteTap = UITapGestureRecognizer()
        let emailTap = UITapGestureRecognizer()
        
        posterLabel.addGestureRecognizer(posterTap)
        phoneLabel.addGestureRecognizer(phoneTap)
        websiteLabel.addGestureRecognizer(websiteTap)
        emailLabel.addGestureRecognizer(emailTap)

        posterTap.rx.event
            .subscribe(onNext: { _ in
                guard let url = URL(string: "http://pticesrbije.rs/wp-content/uploads/2017/04/plakat-SA-A2-druk2b-KONA%C4%8CNA-VERZIJA.jpg?fbclid=IwAR1qQBvEbnDg2MFhvX0bTgPWhzyMrrTzPH0H27NYBKKjvHUJOwka8tidqDE") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        phoneTap.rx.event
            .subscribe(onNext: { _ in
                guard let url = URL(string: "tel://+381216318343") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        websiteTap.rx.event
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://pticesrbije.rs") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        emailTap.rx.event
            .subscribe(onNext: { _ in
                guard let url = URL(string: "mailto:sekretar@pticesrbije.rs") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        facebookButton.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://m.facebook.com/BirdLifeSerbia") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        twitterButton.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://mobile.twitter.com/birdlifeserbia") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        youtubeButton.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://www.youtube.com/channel/UCNSqOYtAkKoDG75HrFYtkqQ") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
        
        instagramButton.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://instagram.com/birdlife_serbia?igshid=1d48pc26mn8vm") else { return }
                UIApplication.shared.open(url)
            }).disposed(by: bag)
    }
}
