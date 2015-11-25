//
//  DetailViewController.swift
//  MemeMe
//
//  Created by zhangyunchen on 15/11/22.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme:Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme?.memedImage
        
        let rightItem = UIBarButtonItem(title: "edit", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        navigationItem.rightBarButtonItem = rightItem

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func edit(){
        performSegueWithIdentifier("detailToEdit", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editVC = segue.destinationViewController as! ViewController
        editVC.meme = meme
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
