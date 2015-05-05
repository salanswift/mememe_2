//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by Jason on 12/12/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class MEMEDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
 
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}
