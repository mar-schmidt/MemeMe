//
//  CustomUITextField.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-30.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import Foundation
import UIKit

class DragableUITextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            
            // Removing constraints. Otherwise the element  will "pop" back when its becoming first responder. This is due to autolayout
            if !self.hasAmbiguousLayout() {
                self.removeConstraints(self.constraints())
                self.setTranslatesAutoresizingMaskIntoConstraints(true)
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            
            // Set our textFields y origin to parent views location
            self.center.y = touch.locationInView(self.superview).y
        }
    }
}
