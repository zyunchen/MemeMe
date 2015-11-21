//
//  ViewController.swift
//  MemeMe
//
//  Created by zhangyunchen on 15/11/20.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topEditText: UITextField!
    
    @IBOutlet weak var bottomEditText: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.whiteColor(),
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        topEditText.defaultTextAttributes = memeTextAttributes
        bottomEditText.defaultTextAttributes = memeTextAttributes
        topEditText.textAlignment = NSTextAlignment.Center
        bottomEditText.textAlignment = NSTextAlignment.Center
        topEditText.delegate = self
        bottomEditText.delegate = self
        shareButton.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNoticifations()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNoticifations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //pick an image from album
    @IBAction func pickImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //pick an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        
        let meme = Meme(topText: topEditText.text!, bottomText: bottomEditText.text!, image: imageView.image!, memedImage: generateMemedImage())
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        self.showViewController(activityViewController, sender: self)
    }
    @IBAction func cancel(sender: AnyObject) {
        imageView.image = nil
        topEditText.text = "TOP"
        bottomEditText.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    func keyboardWillShow(notification:NSNotification){
        if(bottomEditText.isFirstResponder() && self.view.frame.origin.y == 0.0){
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    func keyboardWillDismiss(notification:NSNotification){
        self.view.frame.origin.y = 0.0
    }
    
    func getKeyBoardHeight(notification:NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    func subscribeToKeyboardNoticifations(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDismiss:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNoticifations(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func generateMemedImage() -> UIImage
    {
        toolBar.hidden = true
        navBar.hidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
}

