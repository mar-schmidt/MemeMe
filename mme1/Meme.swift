//
//  Meme.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-29.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

// http://www.raywenderlich.com/76285/beginning-core-image-swift

import Foundation
import UIKit

class Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let originalImageView: UIImageView
    let view: UIView
    
    var memeImage: UIImage?
    
    init(topText: String, bottomText: String, image: UIImage, imageView: UIImageView, view: UIView) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = image
        self.originalImageView = imageView
        self.view = view
    }
    
    func createMemeImageFromObject(meme: Meme) -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(meme.view.frame.size)
        meme.view.drawViewHierarchyInRect(meme.view.frame,
            afterScreenUpdates: true)
        var memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        memedImage = cropImage(memedImage, rect: meme.originalImageView.frame)
        
        memeImage = memedImage
        
        return memedImage
    }
    
    private func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
        
        return UIImage(CGImage: imageRef)!
    }
}