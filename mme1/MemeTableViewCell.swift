//
//  MemeTableViewCell.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-09-04.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    func setProperties(image: UIImage, topLabel: String, bottomLabel: String) {
        self.memeImageView.image = image
        self.topLabel.text = topLabel
        self.bottomLabel.text = bottomLabel
        
        self.backgroundImageView.image = image
    }
}
