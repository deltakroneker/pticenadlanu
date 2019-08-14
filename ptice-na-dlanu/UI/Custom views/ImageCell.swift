//
//  ImageCell.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/17/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var imageName: String? {
        didSet {
            if let imageName = imageName,
                let image = UIImage(named: imageName) {
                imageView.image = image
            }
        }
    }
}
