//
//  Storyboarded.swift
//  genrenator
//
//  Created by Nikola Milic on 3/27/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case home = "Home"
    case list = "List"
    case details = "Details"
    case options = "Options"
}

protocol Storyboarded {
    static func instantiate(from: StoryboardName) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(from storyboard: StoryboardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
