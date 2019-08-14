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

    // MARK: - Outlets
    
    @IBOutlet weak var shapeCollectionView: UICollectionView!
    @IBOutlet weak var shapeContainerView: UIView!
    
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var locationContainerView: UIView!
    
    @IBOutlet var lineViews: [UIView]!
    @IBOutlet var featherColorButtons: [UIButton]!
    @IBOutlet weak var resultButton: UIButton!
    
    @IBOutlet weak var navBarRightItem: UIBarButtonItem!
    @IBOutlet weak var navBarLeftItem: UIBarButtonItem!
    
    // MARK: - Vars & Lets
    
    let shapeGradientLayer = ItemGradientLayer()
    let locationGradientLayer = ItemGradientLayer()
    
    let widthPercent: CGFloat = 0.5
    
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeCollectionView.delegate = self
        locationCollectionView.delegate = self
        setupController()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeGradientLayer.frame = shapeContainerView.bounds
        locationGradientLayer.frame = locationContainerView.bounds
    }
    
    // MARK: - Methods
    
    fileprivate func setupController() {
        navBarLeftItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 20)!], for: .disabled)
        resultButton.layer.cornerRadius = 5
        resultButton.layer.masksToBounds = false
        
        for view in lineViews { view.layer.cornerRadius = view.frame.height / 2 }
        for button in featherColorButtons {
            guard let imageName = FeatherColor.fromTag(tag: button.tag)?.rawValue,
                let image = UIImage(named: imageName) else { return }
            button.setImage(image, for: .selected)
        }
        shapeContainerView.layer.mask = shapeGradientLayer
        locationContainerView.layer.mask = locationGradientLayer
    }
    
    fileprivate func setupBindings() {
        let shapeDragging = shapeCollectionView.rx.didEndDragging.filter { $0 == false }
        let shapeScrolling = shapeCollectionView.rx.didEndScrollingAnimation.asObservable().startWith(())
        let shapeDecelerating = shapeCollectionView.rx.didEndDecelerating.asObservable().startWith(())

        let shapeInput = Observable
            .combineLatest(shapeDragging, shapeScrolling, shapeDecelerating)
            .map { _ -> Void in return () }
            .map { [weak self] () -> BirdShape? in
                guard let indexPath = self?.shapeCollectionView.centerCellIndexPath,
                    let cell = self?.shapeCollectionView.cellForItem(at: indexPath) as? PickerItemCell,
                    let item = cell.viewModel as? ShapeItem else { return nil }
                return item.shape
            }.startWith(.all)
        
        let locationDragging = locationCollectionView.rx.didEndDragging.filter { $0 == false }
        let locationScrolling = locationCollectionView.rx.didEndScrollingAnimation.asObservable().startWith(())
        let locationDecelerating = locationCollectionView.rx.didEndDecelerating.asObservable().startWith(())
        
        let locationInput = Observable
            .combineLatest(locationDragging, locationScrolling, locationDecelerating)
            .map { _ -> Void in return () }
            .map { [weak self] () -> BirdLocation? in
                guard let indexPath = self?.locationCollectionView.centerCellIndexPath,
                    let cell = self?.locationCollectionView.cellForItem(at: indexPath) as? PickerItemCell,
                    let item = cell.viewModel as? LocationItem else { return nil }
                return item.location
            }.startWith(.all)
        
        let input = HomeViewModel.Input(shape: shapeInput, location: locationInput)
        let output = viewModel.transform(input: input)
        
        output.newShapeData
            .bind(to: shapeCollectionView.rx.items(dataSource: shapeDataSource))
            .disposed(by: bag)
        
        output.newLocationData
            .bind(to: locationCollectionView.rx.items(dataSource: locationDataSource))
            .disposed(by: bag)
        
        output.isButtonEnabled
            .drive(resultButton.rx.isEnabled)
            .disposed(by: bag)

        output.buttonLabelText
            .drive(resultButton.rx.title(for: .normal))
            .disposed(by: bag)
        
        for button in featherColorButtons {
            button.rx.tap
                .map { FeatherColor.fromTag(tag: button.tag) }
                .subscribe(onNext: { [weak self] in
                    guard let self = self, let newColor = $0 else { return}
                    var colors = self.viewModel.selectedColors.value
                    
                    if Set(colors).contains(newColor) {
                        guard let position = colors.firstIndex(of: newColor) else { return }
                        colors.remove(at: position)
                    } else {
                        colors.append(newColor)
                    }
                    self.viewModel.selectedColors.accept(colors)
                }).disposed(by: bag)
        }
        
        viewModel.selectedColors
            .subscribe(onNext: { [weak self] colors in
                guard let self = self else { return }
                let tags = colors.map { $0.asInt() }
                let selectedButtons = self.featherColorButtons.filter { tags.contains($0.tag) }
                let nonSelectedButtons = self.featherColorButtons.filter { !tags.contains($0.tag) }
                selectedButtons.forEach {
                    $0.isSelected = true
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                nonSelectedButtons.forEach {
                    $0.isSelected = false
                    $0.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }).disposed(by: bag)
    
        resultButton.rx.tap
            .withLatestFrom(output.matchingBirds)
            .subscribe(onNext: { [weak self] (birds) in
                guard let self = self, let title = self.resultButton.titleLabel?.text else { return }
                self.coordinator?.resultButtonPressed(title, birds)
            }).disposed(by: bag)
        
        navBarRightItem.rx.tap
            .subscribe{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.optionsButtonPressed()
            }.disposed(by: bag)
        
        self.viewModel.selectedColors.accept([])
    }
}

// MARK: - CollectionView

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * widthPercent,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: shapeCollectionView.frame.width * (1 - widthPercent) / 2,
                            bottom: 0, right: shapeCollectionView.frame.width * (1 - widthPercent) / 2)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell(scrollView: scrollView)
        }
    }
    
    fileprivate func scrollToNearestVisibleCollectionViewCell(scrollView: UIScrollView) {
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

extension UICollectionView {
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: center.x + contentOffset.x,
                           y: center.y + contentOffset.y)
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        return indexPathForItem(at: centerPoint)
    }
}
