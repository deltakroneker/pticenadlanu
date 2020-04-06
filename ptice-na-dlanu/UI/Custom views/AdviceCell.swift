//
//  AdviceCell.swift
//  ptice-na-dlanu
//
//  Created by Jelena Krmar on 06/04/2020.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

protocol AdviceDelegate {
    func toggleAdvice(_ row: Int)
    func shareTapped()
}

class AdviceCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var adviceImage: UIImageView!
    @IBOutlet weak var collapseButton: UIButton!
    
    var delegate: AdviceDelegate?
    
    var row = -1
    
    var advice: BirdwatchAdvice? {
        didSet {
            if let advice = advice {
                titleLabel.text = advice.title
                explanationLabel.text = advice.explanation
                
                if advice.isCollapsed {
                    collapseButton.setImage(UIImage.init(named: "plus"), for: .normal)
                    explanationLabel.isHidden = true
                    adviceImage.isHidden = true
                    shareButton.isHidden = true
                }
                else {
                    collapseButton.setImage(UIImage.init(named: "minus"), for: .normal)
                    explanationLabel.isHidden = false
                    adviceImage.isHidden = false
                    shareButton.isHidden = !advice.showShare
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cardTapped))
        
        titleLabel.addGestureRecognizer(tap)
        collapseButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        cardView.layer.cornerRadius = 2
        cardView.layer.shadowColor = UIColor.init(named: "darkGray")!.cgColor
        cardView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOpacity = 0.6
        
    }
 
    @objc private func cardTapped() {
        if row > -1 {
            delegate?.toggleAdvice(row)
        }
    }
    
    @objc private func shareTapped() {
        delegate?.shareTapped()
    }
}

