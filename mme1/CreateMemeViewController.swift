//
//  CreateMemeViewController.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-25.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MemeLabels outlets
    @IBOutlet weak var topTextField: DragableUITextField!
    @IBOutlet weak var bottomTextField: DragableUITextField!
    
    // textFields delegates objects
    let textFieldDelegate = CustomTextFieldDelegate()
    
    var meme: Meme?
    var index: NSInteger?
    
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
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        if (meme != nil) {
            topTextField.text = meme?.topText
            bottomTextField.text = meme?.bottomText
            imagePickerView.image = meme?.originalImage
            shareButton.enabled = true
        }
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
        
        if var memedImage = meme.memeImage as UIImage! {
            
            // Create the activityViewController
            let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch13p635activityView/ch26p901activityView/ViewController.swift
            activityViewController.completionWithItemsHandler = {
                (type: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
                
                if ok {
                    // Cast the activity type (gotten from activityViewControllers completehandler. We do this so that we can make use of NSStrings method "rangeOfString". This will allow us to determine if user saved the image to camera roll or shared it
                    var activityType = type as NSString
                    var activityTypeRangeCameraRoll = activityType.rangeOfString("SaveToCameraRol")
                    
                    // If activityType is camera roll
                    if (activityTypeRangeCameraRoll.location != NSNotFound) {
                        // Activity type is camera roll
                        self.presentDismissableAlertViewControllerWithTitle("Successful!", message: "Your image was successfully saved", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK", completionHandler: { (success) -> Void in
                            
                            self.dismissViewControllerAndSaveData(meme)
                        })

                    } else {
                        // Activity type is not camera roll
                        self.presentDismissableAlertViewControllerWithTitle("Successful!", message: "Your image was successfully shared", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK", completionHandler: { (success) -> Void in
                            
                            self.dismissViewControllerAndSaveData(meme)
                        })

                    }
                }
            }
            // Everything is set up, now present the activityViewController
            presentViewController(activityViewController, animated: true, completion: nil)
            
        } else {
            presentDismissableAlertViewControllerWithTitle("Issue", message: "Problem when creating the meme image. Please try again", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK", completionHandler: { (success) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })

            
            presentDismissableAlertViewControllerWithTitle("Issue", message: "Problem when creating the meme image. Please try again", preferredStyle: UIAlertControllerStyle.Alert, dismissText: "OK", completionHandler: { (success) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func presentDismissableAlertViewControllerWithTitle(title: String, message: String, preferredStyle: UIAlertControllerStyle, dismissText: String, completionHandler: (success: Bool) -> Void) {
        
        // Set the UIAlertController with arguments provided in method arguments
        var alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        // Add dismissaction with text provided in method arguments
        alert.addAction(UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            completionHandler(success: true)
        }))
        
        // Present it
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func dismissViewControllerAndSaveData(meme: Meme) {
        // Save the meme to memes array in appDelegate
        if index != nil {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index!)
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}















