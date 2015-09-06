//
//  MemeCollectionViewCell.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-09-04.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    
    var image: UIImage!
    var bottomString: String!
    var topString: String!
    
    
    func setText(topText: String, bottomText: String) {
        self.topString = topText
        self.bottomString = bottomText
    }
}
