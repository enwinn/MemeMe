//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Eric Winn on 5/24/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import UIKit

//let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Shared Model
    var memes = [Meme]()
    
    // MARK: - Setup
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.collectionView?.reloadData()
    }
    
    // MARK: - Collection View functions
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Connect the dots...
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    // Show detail view - hidden tab bar
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // Launch Meme Editor (Note: Since it was the initial VC so just going back in reality)
    @IBAction func addMemeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

