//
//  ListViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/14/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ListViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    
    @IBOutlet weak var birdCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    var viewModel: ListViewModel!
    let bag = DisposeBag()
    
    let birdDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, BirdItem>>(configureCell: {
        (dataSource, cv, indexPath, birdVM) -> UICollectionViewCell in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "PickerItemCell", for: indexPath) as! ImageWithTitleCell
        cell.viewModel = birdVM
        return cell
    })
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        birdCollectionView.delegate = self
        
        setupSearchBar()
        setupBindings()
    }
    
    // MARK: - Methods
    
    fileprivate func setupSearchBar() {
        searchBar.delegate = self
        
        // Fonts
        let searchBarFont = UIFont.init(name: "OpenSans-Regular", size: 16.0)
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = searchBarFont // Text
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = searchBarFont // Placeholder
    }
    
    fileprivate func setupBindings() {
        let input = ListViewModel.Input(searchText: searchBar.rx.text.orEmpty.asObservable())
        let output = viewModel.transform(input: input)
        
        output.resultCountTitle
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
        output.matchedBirdsData
            .bind(to: birdCollectionView.rx.items(dataSource: birdDataSource))
            .disposed(by: bag)
        
        birdCollectionView.rx.itemSelected
            .map { [weak self] (indexPath) -> BirdItem? in
                guard let cell = self?.birdCollectionView.cellForItem(at: indexPath) as? ImageWithTitleCell,
                    let item = cell.viewModel as? BirdItem else { return nil }
                return item
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self, let item = $0 else { return }
                self.searchBar.resignFirstResponder()
                self.coordinator?.birdItemPressed(item: item)
            }).disposed(by: bag)
    }
}

// MARK: - CollectionView

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: collectionView.frame.width / 3 - 11,
            height: collectionView.frame.width / 3 - 11)
        }
        
        return CGSize(width: collectionView.frame.width / 2 - 5,
                      height: collectionView.frame.width / 2 - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - SearchBar

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
