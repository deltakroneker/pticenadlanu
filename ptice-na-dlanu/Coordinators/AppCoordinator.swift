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
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 18)!]
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
    
//    func showListOfGenres() {
//        guard let mainVC = self.navigationController.viewControllers.first as? MainViewController,
//            let mainVM = mainVC.viewModel else { return }
//        
//        let vc = ListViewController.instantiate(from: .main)
//        vc.coordinator = self
//        vc.viewModel = ListViewModel(allGenres: mainVM.allGenres)
//        vc.title = "All genres"
//        navigationController.pushViewController(vc, animated: true)
//    }
}
