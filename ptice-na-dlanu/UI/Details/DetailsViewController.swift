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
    
    @IBOutlet weak var birdLengthLabel: UILabel!
    @IBOutlet weak var wingSpanLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nestLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var endangeredImageView: UIImageView!
    @IBOutlet weak var endangeredLabel: UILabel!
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    var viewModel: DetailsViewModel!
    let bag = DisposeBag()
    
    let widthPercent: CGFloat = 0.5
    
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
        setupBindings()
    }
    
    // MARK: - Methods
    
    fileprivate func setupBindings() {
        viewModel.birdItem.asObservable()
            .map { $0?.bird }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let speciesName = NSMutableAttributedString(string: ($0?.srpskiNazivVrste ?? "") + " ")
                speciesName.append(NSMutableAttributedString(string: "(" + ($0?.naucniNazivVrste ?? "") + ")",
                                                             attributes: [NSAttributedString.Key.font: UIFont(name: "OpenSans-Italic", size: 17)!]))
                self.speciesNameLabel.attributedText = speciesName
                self.familyNameLabel.text = $0?.porodica
                self.birdLengthLabel.text = ($0?.duzinaTela ?? "-") + " cm"
                self.wingSpanLabel.text = ($0?.rasponKrila ?? "-") + " cm"
                self.weightLabel.text = ($0?.masa ?? "-") + " g"
                self.descriptionLabel.text = $0?.glavniTekst
                self.nestLabel.text = ($0?.gnezdaricaNegnezdarica ?? "") + " " + ($0?.the1 ?? "")
                self.foodLabel.text = "Glavna hrana ove ptice su: " + ($0?.ishrana ?? "")
                self.endangeredLabel.isHidden = ($0?.ugrozena == "NE")
                self.endangeredImageView.isHidden = ($0?.ugrozena == "NE")
            }).disposed(by: bag)
        
        let output = viewModel.transform(input: nil)

        output.isPageControlHidden
            .bind(to: imagePageControl.rx.isHidden)
            .disposed(by: bag)
        
        output.imagesData
            .bind(to: imageCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: bag)
    }
}

// MARK: - CollectionView

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10,
                      height: collectionView.frame.width / 2 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width / 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: collectionView.frame.width * (1 - widthPercent) / 2,
                            bottom: 0, right: collectionView.frame.width * (1 - widthPercent) / 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.imageCollectionView else { return }
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        imagePageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}
