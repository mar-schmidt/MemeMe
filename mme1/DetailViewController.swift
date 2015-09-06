//
//  DetailViewController.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-09-04.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var index: NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        // Hide the tabbar since we're in detailed view, user has to use navigation to come back
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView.image = meme.memeImage
    }
    
    // This sets the meme object so that we can send it further to "createMemeViewController".
    func setMeme(meme: Meme, atIndex: NSInteger) {
        self.meme = meme
        self.index = atIndex
    }
    
    func editMeme() {
        var createMemeViewController = storyboard?.instantiateViewControllerWithIdentifier("createMemeViewController") as! CreateMemeViewController
        createMemeViewController.meme = meme
        createMemeViewController.index = index
        
        presentViewController(createMemeViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Now lets show the tabbar again since we're leaving the detailed view
        self.tabBarController?.tabBar.hidden = false
    }
}
