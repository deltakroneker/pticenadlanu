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
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 20)!]
        }
    }
    
    func start() {
        let vc = HomeViewController.instantiate(from: .home)
        vc.coordinator = self
        vc.viewModel = HomeViewModel()
        vc.title = "Pronađimo pticu"
        navigationController.pushViewController(vc, animated: false)
    }
}

extension AppCoordinator {
    
    func resultButtonPressed(_ title: String, _ birds: [BirdItem]) {
        let vc = ListViewController.instantiate(from: .list)
        vc.coordinator = self
        vc.viewModel = ListViewModel()
        vc.viewModel.matchedBirds.accept(birds)
        vc.title = title
        navigationController.pushViewController(vc, animated: true)
    }
    
    func birdItemPressed(item: BirdItem) {
        let vc = DetailsViewController.instantiate(from: .details)
        vc.coordinator = self
        vc.viewModel = DetailsViewModel()
        vc.title = item.bird.srpskiNazivVrste
        navigationController.pushViewController(vc, animated: true)
    }
}
