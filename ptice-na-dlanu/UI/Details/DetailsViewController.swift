//
//  DetailsViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/15/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AVFoundation

class DetailsViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var speciesNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var synonymLabel: UILabel!
    @IBOutlet weak var synonymTitleLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    @IBOutlet weak var birdLengthLabel: UILabel!
    @IBOutlet weak var wingSpanLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nestLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var endangeredImageView: UIImageView!
    @IBOutlet weak var endangeredLabel: UILabel!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet var endangeredImageHeight: NSLayoutConstraint!
    @IBOutlet var endangeredBottom: NSLayoutConstraint!
    
    @IBOutlet var videoButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var audioStackView: UIStackView!
    @IBOutlet var audioTypeButtons: [UIButton]!
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    var viewModel: DetailsViewModel!
    let bag = DisposeBag()
    
    private var playerItemContext = 0
    var videoLink = ""
    var audioPlayer: AVPlayer? {
        didSet {
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    let regularImage: CGFloat = 250
    let smallerImage: CGFloat = 210
    let largerImage: CGFloat = 350
    
    let imagesDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {
        (dataSource, cv, indexPath, imageName) -> UICollectionViewCell in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageName = imageName
        return cell
    })
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        tweakImageSize()
        setupBindings()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWentToBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    fileprivate func tweakImageSize() {
        if UIScreen.main.bounds.height <= 568 { // iPhone SE
            collectionViewHeight.constant = smallerImage
        }
        else if UIScreen.main.bounds.height <= 896 {
            collectionViewHeight.constant = regularImage
        }
        else {
            collectionViewHeight.constant = largerImage // iPads
        }
    }
    
    @objc fileprivate func appWentToBackground() {
        DispatchQueue.main.async {
            self.audioPlayer?.rate = 0.0
            self.audioPlayer?.pause()
            self.audioButton.setImage(UIImage(named: "audio_start"), for: .normal)
        }
    }
    
    fileprivate func setupBindings() {
        viewModel.birdItem.asObservable()
            .map { $0?.bird }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let speciesName = NSMutableAttributedString(string: ($0?.srpskiNazivVrste ?? "") + " ")
                speciesName.append(NSMutableAttributedString(string: "(" + ($0?.naucniNazivVrste ?? "") + ")",
                                                             attributes: [NSAttributedString.Key.font: UIFont(name: "OpenSans-Italic", size: 15)!]))
                self.speciesNameLabel.attributedText = speciesName
                self.familyNameLabel.text = $0?.porodica
                self.englishLabel.text = $0?.engleskiNazivVrste
                
                let hasSynonims = $0?.sinonimi == ""
                self.synonymTitleLabel.isHidden = hasSynonims
                self.synonymLabel.isHidden = hasSynonims
                self.synonymLabel.text = $0?.sinonimi
                
                self.birdLengthLabel.text = ($0?.duzinaTela ?? "-") + " cm"
                self.wingSpanLabel.text = ($0?.rasponKrila ?? "-") + " cm"
                self.weightLabel.text = ($0?.masa ?? "-") + " g"
                self.descriptionLabel.text = $0?.glavniTekst
                self.nestLabel.text = ($0?.gnezdaricaNegnezdarica ?? "") + " " + ($0?.prisutnost ?? "")
                
                let foodDesc = $0?.ishrana ?? ""
                var foodText = ""
                
                if (foodDesc.contains("svaštojed")) {
                    foodText = "Ova ptica je:\n\(foodDesc)."
                }
                else {
                    foodText = "Glavna hrana ove ptice su:\n\(foodDesc)."
                }
                
                self.foodLabel.text = foodText
                
                let notEndangered = ($0?.ugrozena == "NE")
                
                self.endangeredLabel.isHidden = notEndangered
                self.endangeredImageView.isHidden = notEndangered
                self.endangeredImageHeight.constant = notEndangered ? 0 : 40
                self.endangeredBottom.constant = notEndangered ? 0 : 30
                
                self.videoLink = $0?.video ?? ""
                self.videoButton.isHidden = self.videoLink == ""
                self.audioButton.isHidden = ($0?.brojZvukova ?? "0") == "0"
                
                let birdObj = $0
                self.audioTypeButtons.forEach { [weak self] button in
                    guard let self = self else { return }
                    switch (button.tag) {
                    case 0: button.isHidden = birdObj?.pesma == ""; break
                    case 1: button.isHidden = birdObj?.zov == ""; break
                    case 2: button.isHidden = birdObj?.pesmaZenke == ""; break
                    case 3: button.isHidden = birdObj?.zovMladih == ""; break
                    case 4: button.isHidden = birdObj?.letniZov == ""; break
                    case 5: button.isHidden = birdObj?.zovUzbune == ""; break
                    default: break
                    }
                    button.rx.tap.subscribe(onNext: { [weak self] tap in
                        guard let self = self else { return }
                        var url: URL?
                        switch (button.tag) {
                        case 0: url = URL(string: (birdObj?.pesma ?? "") + "/download"); break
                        case 1: url = URL(string: (birdObj?.zov ?? "") + "/download"); break
                        case 2: url = URL(string: (birdObj?.pesmaZenke ?? "") + "/download"); break
                        case 3: url = URL(string: (birdObj?.zovMladih ?? "") + "/download"); break
                        case 4: url = URL(string: (birdObj?.letniZov ?? "") + "/download"); break
                        case 5: url = URL(string: (birdObj?.zovUzbune ?? "") + "/download"); break
                        default: break
                        }
                        self.audioStackView.isHidden.toggle()
                        guard let link = url else { return }
                        self.audioPlayer = AVPlayer(url: link)
                        guard let player = self.audioPlayer else { return }
                        player.currentItem?.addObserver(self,
                                                        forKeyPath: #keyPath(AVPlayerItem.status),
                                                        options: [.old, .new],
                                                        context: &self.playerItemContext)
                        player.actionAtItemEnd = .pause
                        player.play()
                        self.audioButton.setImage(UIImage(named: "audio_loading"), for: .normal)
                    }).disposed(by: self.bag)
                }
            }).disposed(by: bag)
        
        let output = viewModel.transform(input: nil)

        output.isPageControlHidden
            .bind(to: imagePageControl.rx.isHidden)
            .disposed(by: bag)
        
        output.numberOfPages
            .bind(to: imagePageControl.rx.numberOfPages)
            .disposed(by: bag)
        
        output.imagesData
            .bind(to: imageCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: bag)
        
        videoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator?.videoButtonPressed(self.videoLink)
            }).disposed(by: bag)
        
        audioButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let player = self.audioPlayer else {
                    self.audioStackView.isHidden.toggle()
                    return
                }
                if player.rate > 0 {
                    player.pause()
                    self.audioButton.setImage(UIImage(named: "audio_start"), for: .normal)
                } else {
                    self.audioStackView.isHidden.toggle()
                }
            }).disposed(by: bag)
    }
    
    @objc func playerDidFinishPlaying() {
        DispatchQueue.main.async {
            self.audioButton.setImage(UIImage(named: "audio_start"), for: .normal)
        }
    }
}

// MARK: - CollectionView

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width - collectionView.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (collectionView.frame.width - collectionView.frame.height) / 2,
                            bottom: 0, right: (collectionView.frame.width - collectionView.frame.height) / 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.imageCollectionView else { return }
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        imagePageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}

extension DetailsViewController {
    
    // Taken from: https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/responding_to_playback_state_changes
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                self.audioButton.setImage(UIImage(named: "audio_stop"), for: .normal)
            case .failed:
                self.showToast(message: "Zvuk nije moguće učitati.", width: 220)
                self.audioButton.setImage(UIImage(named: "audio_start"), for: .normal)
            case .unknown:
                self.audioButton.setImage(UIImage(named: "audio_start"), for: .normal)
            default: break
            }
        }
    }
    
    func showToast(message : String, width: CGFloat) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - width/2, y: self.view.frame.size.height-80, width: width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
