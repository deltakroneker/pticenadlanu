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

class DetailsViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var speciesNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var synonymLabel: UILabel!
    @IBOutlet weak var synonymTitleLabel: UILabel!
    
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
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    var viewModel: DetailsViewModel!
    let bag = DisposeBag()
    
    var videoLink = ""
        
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
