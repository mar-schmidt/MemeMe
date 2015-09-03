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

struct Meme {
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
        
        self.memeImage = createMemeImageFromObject(self)
    }
    
    mutating func createMemeImageFromObject(meme: Meme) -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(meme.view.frame.size)
        meme.view.drawViewHierarchyInRect(meme.view.frame,
            afterScreenUpdates: true)
        var memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Crop the image to the frame of the imageView, this will avoid getting other UIElements (like toolbars) in the final image
        memedImage = cropImage(memedImage, rect: meme.originalImageView.frame)
        
        // Assign the cropped image to the memeImage property
        self.memeImage = memedImage
        
        // Return it
        return memedImage
    }
    
    private func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        // This methid will crop the image to the CGRect of the provided image
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
        
        return UIImage(CGImage: imageRef)!
    }
}