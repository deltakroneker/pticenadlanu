//
//  AuthorsViewController.swift
//  ptice-na-dlanu
//
//  Created by Jelena on 03/02/2020.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

class AuthorsViewController: UIViewController, Storyboarded {

    @IBOutlet var authorsTable: UITableView!
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
