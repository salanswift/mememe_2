//
//  VillainCollectionViewController.swift
//  BondVillains
//
//  Created by Gabrielle Miller-Messner on 2/3/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

import UIKit

class MEMECollectionViewController: UIViewController, UICollectionViewDataSource {
    
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Creation of Button on Navigation Bar to dismiss the TabBarcontroller
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("openEditor"))
        
    }
    
    func openEditor() // Dismisses the TabBarcontroller
    {
        let editorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.presentViewController(editorViewController, animated: false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        memeCollectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MEMECollectionViewCell", forIndexPath: indexPath) as! MEMECollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.topLabel.text = meme.topFieldText
        cell.memeImageView?.image = meme.memedImage
        cell.bottomLabel.text = meme.bottomFieldText
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MEMEDetailViewController") as! MEMEDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
