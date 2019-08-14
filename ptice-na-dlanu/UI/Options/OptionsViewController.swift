//
//  OptionsViewController.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/25/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OptionsViewController: UIViewController, Storyboarded {

    // MARK: - Outlets

    @IBOutlet weak var optionsTableView: UITableView!
    
    // MARK: - Vars & Lets

    weak var coordinator: AppCoordinator?
    let bag = DisposeBag()

    let optionsDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tv, indexPath, title) -> UITableViewCell in
        let cell = tv.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = title
        return cell
    })
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        setupBindings()
    }
    
    // MARK: - Methods

    fileprivate func setupBindings() {
        Observable.just([SectionModel<String, String>(model: "", items: ["O aplikaciji", "O nama"])])
            .bind(to: optionsTableView.rx.items(dataSource: optionsDataSource))
            .disposed(by: bag)
        
        optionsTableView.rx.itemSelected
            .subscribe(onNext: {
                switch ($0.row) {
                case 0: self.coordinator?.applicationInfoCellPressed()
                case 1: self.coordinator?.aboutUsCellPressed()
                default: break
                }
            }).disposed(by: bag)
    }
}

// MARK: - TableView

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
