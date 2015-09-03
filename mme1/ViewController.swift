//
//  ViewController.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-25.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MemeLabels outlets
    @IBOutlet weak var topTextField: DragableUITextField!
    @IBOutlet weak var bottomTextField: DragableUITextField!
    
    // textFields delegates objects
    let textFieldDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Appearence setup of our top/bottomTextfields
        setupTextFieldProperties(topTextField, text: "TOP")
        setupTextFieldProperties(bottomTextField, text: "BOTTOM")
        
        // Set their alignments to center-aligned - Apparantly needs to be se directly on the property
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        // Set their delegate
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        // Disable shareButton, this will be enabled when user has picked an image
        shareButton.enabled = false
    }
    
    func setupTextFieldProperties(textField: DragableUITextField, text: String) {
        
        // Set the textFields text from parameter text
        textField.text = text

        // Setup the character attributes
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]
        
        // Set them to our textField
        textField.defaultTextAttributes = textAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if device has camera, if not; disable camera button
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        // Setup the properties for pickerController
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Present it
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        // Setup the properties for pickerController
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        // Present it
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Set the imaged returned by UIImagePickerController as the image of the imagePickerView
            imagePickerView.image = image
            
            // Also enable the shareButton
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func share(sender: AnyObject) {
        
        // Create our meme object
        let meme = Meme(
            topText: topTextField.text,
            bottomText: bottomTextField.text,
            image: imagePickerView.image!,
            imageView: imagePickerView,
            view: self.view)
        
        var memedImage = meme.createMemeImageFromObject(meme)
        
        // Create the activityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        
        // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch13p635activityView/ch26p901activityView/ViewController.swift
        activityViewController.completionWithItemsHandler = {
            (type: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            
            if ok {
                println("completed \(type) \(ok) \(items) \(err)")
            
                var activityType = type as NSString
                var activityTypeRange = activityType.rangeOfString("SaveToCameraRol")
                
                if (activityTypeRange.location != NSNotFound) {
                    
                    self.presentDismissableAlertViewControllerWithTitle("Successful!", message: "Your image was successfully saved", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK")
                } else {
                    self.presentDismissableAlertViewControllerWithTitle("Successful!", message: "Your image was successfully shared", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK")
                }
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func presentDismissableAlertViewControllerWithTitle(title: String, message: String, preferredStyle: UIAlertControllerStyle, dismissText: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alert.addAction(UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}















