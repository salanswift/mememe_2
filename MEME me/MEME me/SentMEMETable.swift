//
//  SentMEMETable.swift
//  MEME me
//
//  Created by Arsalan Akhtar on 02/05/2015.
//  Copyright (c) 2015 Arsalan Akhtar. All rights reserved.
//

import UIKit


class SentMEMETable: UIViewController, UITableViewDataSource,UITableViewDelegate
{
    
    
    @IBOutlet weak var sentMemeTable: UITableView!
    
    var memes: [Meme]!
    let object = UIApplication.sharedApplication().delegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        //Creation of Button on Navigation Bar to dismiss the TabBarcontroller
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("openEditor"))
        
        if((object as! AppDelegate).memes.count == 0)
        {
            openEditor()
        }
        
    }
    
    
    func openEditor() // Dismisses the TabBarcontroller
    {
        let editorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            self.presentViewController(editorViewController, animated: false, completion: nil)
    
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let appDelegate = object as! AppDelegate
        memes = (object as! AppDelegate).memes
        sentMemeTable.reloadData()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
       
        cell.imageView?.image = meme.memedImage
       
        cell.textLabel?.text = "\(meme.topFieldText) \(meme.bottomFieldText)"
        
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Grab an instance of the DetailViewController from the storyboard
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MEMEDetailViewController") as! MEMEDetailViewController
        
        //Populate view controller with data according to the selected cell
        detailController.meme = self.memes[indexPath.row]
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
        
    {
        return true
    }
}