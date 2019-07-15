//
//  PickerItemCell.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

class PickerItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: Item! {
        didSet {
            titleLabel.text = viewModel.text
            if let image = UIImage(named: viewModel.image) {
                imageView.image = image
            }
        }
    }
}
