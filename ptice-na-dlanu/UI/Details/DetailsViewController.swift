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

    // MARK: - Vars & Lets
    
    weak var coordinator: AppCoordinator?
    var viewModel: DetailsViewModel!
    let bag = DisposeBag()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
