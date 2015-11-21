//
//  Meme.swift
//  MemeMe
//
//  Created by zhangyunchen on 15/11/21.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//
import UIKit

public class Meme{
    
    var topText:String
    var bottomText:String
    var image:UIImage?
    var memedImage:UIImage?
    
    public init(topText:String,bottomText:String,image:UIImage,memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
    
}
