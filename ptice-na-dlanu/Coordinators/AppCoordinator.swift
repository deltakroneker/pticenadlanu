//
//  AppCoordinator.swift
//  genrenator
//
//  Created by Nikola Milic on 3/4/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        if let green = UIColor(named: "colorPrimary") {
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = green
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 19)!]
        }
    }
    
    func start() {
        let vc = HomeViewController.instantiate(from: .home)
        vc.coordinator = self
        vc.viewModel = HomeViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
}

extension AppCoordinator {
    
    func resultButtonPressed(_ title: String, _ birds: [BirdItem]) {
        let vc = ListViewController.instantiate(from: .list)
        vc.coordinator = self
        vc.viewModel = ListViewModel()
        vc.viewModel.matchedBirds.accept(birds)
        vc.title = title.lowercased()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func birdItemPressed(item: BirdItem) {
        let vc = DetailsViewController.instantiate(from: .details)
        vc.coordinator = self
        vc.viewModel = DetailsViewModel()
        vc.viewModel.birdItem.accept(item)
        vc.title = item.bird.srpskiNazivVrste
        navigationController.pushViewController(vc, animated: true)
    }
    
    func optionsButtonPressed() {
        let vc = AboutViewController.instantiate(from: .about)
        vc.coordinator = self
        vc.title = "Saznajte više"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func applicationInfoCellPressed() {
        let vc = AboutAppViewController.instantiate(from: .about)
        vc.coordinator = self
        vc.title = "O aplikaciji \"Ptice na dlanu\""
        navigationController.pushViewController(vc, animated: true)
    }
    
    func aboutUsCellPressed() {
        let vc = AboutUsViewController.instantiate(from: .about)
        vc.coordinator = self
        vc.title = "O nama - DZPPS"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func adviceCellPressed() {
        let vc = AdviceViewController.instantiate(from: .about)
        vc.coordinator = self
        vc.title = "10 saveta za posmatranje ptica"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func videoButtonPressed(_ link: String) {
        let vc = VideoViewController.instantiate(from: .details)
        vc.coordinator = self
        vc.videoURL = link
        navigationController.pushViewController(vc, animated: true)
    }
    
    func authorsButtonPressed() {
        let vc = AuthorsViewController.instantiate(from: .about)
        vc.coordinator = self
        vc.title = "Zvukovi ptica u aplikaciji"
        navigationController.pushViewController(vc, animated: true)
    }
}
