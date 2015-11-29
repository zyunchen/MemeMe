//
//  MemesViewController.swift
//  MemeMe
//
//  Created by zhangyunchen on 15/11/22.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        //TODO 这里动画不对
        tabBarController?.tabBar.hidden = false
    }

    
    // these for tableview datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("get numbers of rows \(memes.count)")
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell")! as UITableViewCell
        let meme = memes[indexPath.item]
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("DeatilViewController")
//        let detailVC = object as! DetailViewController
//        detailVC.meme = memes[indexPath.row]
//TODO:        detailVC.hidesBottomBarWhenPushed = true  , why this doesn't work
        tabBarController?.tabBar.hidden = true
        performSegueWithIdentifier("detailView", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailView" {
            let detailView = segue.destinationViewController as! DetailViewController
            let index = sender as! NSIndexPath
            detailView.meme = memes[index.row]
        }
    }
    


}
