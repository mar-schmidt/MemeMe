//
//  MemeTableViewController.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-09-04.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        // Reload so that the tableView is always updated after user eventually changed a meme in other places in the app
        self.tableView.reloadData()
        
        enableDisableEditingButtonChecker()
    }
    
    func enableDisableEditingButtonChecker() {
        if memes.count > 0 {
            self.editButtonItem().enabled = true
        } else {
            self.editButtonItem().enabled = false
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.setProperties(meme.memeImage!, topLabel: meme.topText, bottomLabel: meme.bottomText)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
        
        // Populate DetailViewController with the Meme object
        detailViewController.setMeme(memes[indexPath.row], atIndex: indexPath.row)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedMeme = memes[sourceIndexPath.row]
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(sourceIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.insert(movedMeme, atIndex: destinationIndexPath.row)
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // If the editing is a delete. We'll pop up a confirmation dialog in confirmDelete method
        if editingStyle == .Delete {
            confirmDelete(memes[indexPath.row], atIndexPath: indexPath)
        }
    }
    
    func confirmDelete(meme: Meme, atIndexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to delete this meme?", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (alert: UIAlertAction!) -> Void in
            
            // Perform table updates on the tableView as well as memes-array in between begin/endUpdates. We'll do this so that tableView can handle the change of rows visually
            self.tableView.beginUpdates()
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(atIndexPath.row)
            self.tableView.deleteRowsAtIndexPaths([atIndexPath], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            
            // Enable or disable the editingbutton depending on if it was the last item in the table
            self.enableDisableEditingButtonChecker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
}
