//
//  ImageWithTitleCell.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

class ImageWithTitleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: Item! {
        didSet {
            if let vm = viewModel as? BirdItem {
                titleLabel.text = vm.hasFemaleVersion ? vm.text + vm.genderString : vm.text
            } else {
                titleLabel.text = viewModel.text
            }
            
            if let image = UIImage(named: viewModel.image) {
                imageView.image = image
            }
        }
    }
}
