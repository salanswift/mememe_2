//
//  MEME.swift
//  MEME me
//
//  Created by Arsalan Akhtar on 26/04/2015.
//  Copyright (c) 2015 Arsalan Akhtar. All rights reserved.
//

import UIKit


struct Meme
{
    let topFieldText:String
    let bottomFieldText:String
    let imageViewImage:UIImage
    let memedImage:UIImage

    init(topfield:String, bottomField:String, imageView:UIImage, memed:UIImage)
    {
        self.topFieldText = topfield
        self.bottomFieldText = bottomField
        self.imageViewImage = imageView
        self.memedImage = memed
    }
}