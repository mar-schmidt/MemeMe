//
//  MemeCollectionViewController.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-09-04.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //var editModeEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editModeEnabled = false
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        if memes.count == 0 {
            // If we do not have any memes during startup, we'll popup the createMemeViewController
            var createMemeViewController = storyboard?.instantiateViewControllerWithIdentifier("createMemeViewController") as! CreateMemeViewController
            self.presentViewController(createMemeViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.item]
        
        cell.setText(meme.topText, bottomText: meme.bottomText)
        let imageView = UIImageView(image: meme.memeImage)
        
        // Give the delete button an index number
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Add an action function to the delete button
        cell.deleteButton.addTarget(self, action: "deleteMeme:", forControlEvents: .TouchUpInside)
        
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Set the DetailViewController from storyboard
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController

        // Populate DetailViewController with the Meme object
        detailViewController.setMeme(memes[indexPath.item], atIndex: indexPath.item)
        
        // Present the DetailViewController
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        if !editModeEnabled {
            // Put the collection view in edit mode
            editModeEnabled = true
        
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)!
                var cell: MemeCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
                cell.deleteButton.hidden = false // Hide all of the delete buttons
            }
        } else {
            // Take the collection view out of edit mode
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)!
                var cell: MemeCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
                cell.deleteButton.hidden = true  // Hide all of the delete buttons
            }
        }
    }
    
    var editModeEnabled:Bool! {
        didSet {
            if editModeEnabled == false {
                // Put the collection view in non-edit mode
                editButton.title = "Edit"
                self.editButton.style = .Plain
                editModeEnabled = false
                
                for cell in collectionView?.visibleCells() as! [MemeCollectionViewCell] {
                    cell.deleteButton.hidden = true
                }
                
            } else {
                // Put the collection view in edit mode
                editButton.title = "Done"
                self.editButton.style = .Done
                editModeEnabled = true
            }
        }
    }
    
    func deleteMeme(sender: UIButton) {
        // Put the index number of the delete button the use tapped in a variable
        let i: Int = (sender.layer.valueForKey("index")) as! Int
        
        // Remove an object from the dataSource
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(i)
        
        self.collectionView!.reloadData()
        
        if memes.count > 0 {
            editModeEnabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        editModeEnabled = false
    }
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
}
