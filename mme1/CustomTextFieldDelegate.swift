//
//  CustomTextFieldDelegate.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-27.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import Foundation
import UIKit

class CustomTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    var currentTextField = DragableUITextField()
    
    override init() {
        super.init()
        
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Assign currentTextField property the current textField, we do this so that we can access the property later on in this class
        currentTextField = textField as! DragableUITextField
        
        // If text is default text, remove it to clean out for the user to write his/hers own text
        if (currentTextField.text == "TOP" || currentTextField.text == "BOTTOM") {
            currentTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // If the textfields text is empty after entering return, we'll have to highlight the textfield so that the user can find it
        if textFieldHasEmptyText(textField) {
            textField.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        } else {
            textField.backgroundColor = UIColor.clearColor()
        }
        
        // Return true if we can resign as first responder
        if textField.resignFirstResponder() {
            return true
        } else {
            return false
        }
    }
    
    func textFieldIsHiddenByKeyboard(notification: NSNotification) -> Bool {
        var textFieldRect = currentTextField.frame
        textFieldRect.origin.x = 0 // For some reason, textFields y origin is -9. This will break CGRectContainsPoint function
        
        if let dict = notification.userInfo {
            // Get the CGRect of the keyboardFrame provided by NSNotification object
            var keyboardFrame: CGRect = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            keyboardFrame.origin.y -= 100 // There is a UIToolBar above keyboard. Take that into account.
            
            // If active text field will be hidden by keyboard then return true, if not, return false
            if (CGRectContainsPoint(keyboardFrame, textFieldRect.origin)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func textFieldHasEmptyText(textField: UITextField) -> Bool {
        // Check if the textFields text is empty
        if textField.text == "" {
            return true
        } else {
            return false
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Change currentTextFields superview's view (view of CreateMemeViewController) only if keyboard hids the currentTextFields frame
        if textFieldIsHiddenByKeyboard(notification) {
            // This will make the view go up together with the keyboard
            currentTextField.superview!.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // This method checks if viewcontrollers view is not in its original y position (which essentially means that it has been moved in methodkeyboardWillShow:. If its not, we can safetly move it back
        
        var parentViewFrame = currentTextField.superview?.frame
        let windowOriginFrame = currentTextField.superview?.window?.frame
        
        if !(parentViewFrame?.origin.y == windowOriginFrame?.origin.y) {
            currentTextField.superview!.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Notification has a dictionary (userInfo) where we can grab the cgrect-position of the keyboard when its fully up.
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
     deinit {
        unsubscribeToKeyboardNotifications()
    }
}