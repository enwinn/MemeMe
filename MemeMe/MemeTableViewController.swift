//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Eric Winn on 5/23/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: - Shared Model
    var memes: [Meme]!
    
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.tableView?.reloadData()
    }
    
    // MARK: - Table functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of sent memes
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.top + " ... " + meme.bottom
        cell.imageView?.image = meme.memedImage
        cell.backgroundColor = tableView.backgroundColor
        
        return cell
    }
    
    // Detail view: hide bottom bar, animate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // Launch Meme Editor (Note: Since it was the initial VC so just going back in reality)
    @IBAction func addMemeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
