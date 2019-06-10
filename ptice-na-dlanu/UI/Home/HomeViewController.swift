//
//  HomeViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var shapeCollectionView: UICollectionView!
    @IBOutlet weak var shapeContainerView: UIView!
    
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var locationContainerView: UIView!
    
    @IBOutlet var lineViews: [UIView]!
    @IBOutlet var featherColorButtons: [UIButton]!
    
    @IBOutlet weak var resultButton: UIButton!
    
    let shapeGradientLayer = ItemGradientLayer()
    let locationGradientLayer = ItemGradientLayer()
    
    let widthPercent: CGFloat = 0.4
    
    weak var coordinator: AppCoordinator?
    var viewModel: HomeViewModel!
    let bag = DisposeBag()
    
    let shapeDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ShapeItem>>(configureCell: {
        (dataSource, cv, indexPath, shapeVM) -> UICollectionViewCell in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "PickerItemCell", for: indexPath) as! PickerItemCell
        cell.viewModel = shapeVM
        return cell
    })
    
    let locationDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LocationItem>>(configureCell: {
        (dataSource, cv, indexPath, locationVM) -> UICollectionViewCell in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "PickerItemCell", for: indexPath) as! PickerItemCell
        cell.viewModel = locationVM
        return cell
    })

    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeCollectionView.delegate = self
        locationCollectionView.delegate = self
        setupController()
        setupBindings()
        
        viewModel.numberOfBirds(for: .black, .golub, in: .naselje)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeGradientLayer.frame = shapeContainerView.bounds
        locationGradientLayer.frame = locationContainerView.bounds
    }
    
    fileprivate func setupController() {
        for view in lineViews { view.layer.cornerRadius = view.frame.height/2 }
        for button in featherColorButtons {
            guard let imageName = FeatherColor.fromTag(tag: button.tag)?.rawValue,
                let image = UIImage(named: imageName) else { return }
            button.setImage(image, for: .selected)
        }
        shapeContainerView.layer.mask = shapeGradientLayer
        locationContainerView.layer.mask = locationGradientLayer
    }
    
    fileprivate func setupBindings() {
        let output = viewModel.transform(input: nil)
        
        output.newShapeData
            .bind(to: shapeCollectionView.rx.items(dataSource: shapeDataSource))
            .disposed(by: bag)
        
        output.newLocationData
            .bind(to: locationCollectionView.rx.items(dataSource: locationDataSource))
            .disposed(by: bag)
        
        output.isButtonEnabled
            .bind(to: resultButton.rx.isEnabled)
            .disposed(by: bag)

        output.buttonLabelText
            .bind(to: resultButton.rx.title(for: .normal))
            .disposed(by: bag)
        
        for button in featherColorButtons {
            button.rx.tap
                .map { button.isSelected ? false : true }
                .map { $0 == true ? FeatherColor.fromTag(tag: button.tag) : nil }
                .bind(to: viewModel.colorSelected)
                .disposed(by: bag)
        }
        
        viewModel.colorSelected
            .debug()
            .subscribe(onNext: { [weak self] color in
                let tag = color?.asInt()
                let buttons = self?.featherColorButtons.filter {
                    $0.tag == tag ? true : false
                }
                if let button = buttons?.first {
                    button.isSelected = !button.isSelected
                    if button.isSelected {
                        self?.featherColorButtons
                            .filter { $0 == button ? false : true }
                            .forEach { $0.isSelected = false }
                    }
                } else {
                    self?.featherColorButtons
                        .forEach { $0.isSelected = false }
                }
            }).disposed(by: bag)
    }
    
    @IBAction func resultButtonPressed(_ sender: UIButton) {
        print("pressed")
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * widthPercent,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: shapeCollectionView.frame.width * (1-widthPercent)/2,
                            bottom: 0,
                            right: shapeCollectionView.frame.width * (1-widthPercent)/2)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell(scrollView: scrollView)
        }
    }
    
    func scrollToNearestVisibleCollectionViewCell(scrollView: UIScrollView) {
        let middlePoint = Int(scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
        switch scrollView {
        case shapeCollectionView:
            if let indexPath = self.shapeCollectionView.indexPathForItem(at: CGPoint(x: middlePoint, y: 0)) {
                self.shapeCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            break
        case locationCollectionView:
            if let indexPath = self.locationCollectionView.indexPathForItem(at: CGPoint(x: middlePoint, y: 0)) {
                self.locationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            break
        default:
            break
        }
    }
}
