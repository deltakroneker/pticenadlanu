//
//  MaskGradient.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/18/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import UIKit

class ItemGradientLayer: CAGradientLayer {
    
    override init() {
        super.init()
        let clearWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        colors = [clearWhite, clearWhite, UIColor.black.cgColor,
                           UIColor.black.cgColor, clearWhite, clearWhite]
        locations = [0.0, 0.30, 0.301, 0.70, 0.701, 1.0]
        startPoint = CGPoint(x: 0.0, y: 0.5)
        endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
