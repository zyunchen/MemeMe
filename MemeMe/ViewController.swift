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
        
        initTextFiled(topEditText)
        initTextFiled(bottomEditText)
        
        shareButton.enabled = false
        
    }
    
    func initTextFiled(textFiled:UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.whiteColor(),
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        textFiled.defaultTextAttributes = memeTextAttributes
        textFiled.textAlignment = NSTextAlignment.Center
        textFiled.delegate = self
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
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //pick an image from album
    @IBAction func pickImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //pick an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        
        let meme = Meme(topText: topEditText.text!, bottomText: bottomEditText.text!, image: imageView.image!, memedImage: generateMemedImage())
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        showViewController(activityViewController, sender: self)
    }
    @IBAction func cancel(sender: AnyObject) {
        imageView.image = nil
        topEditText.text = "TOP"
        bottomEditText.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    func keyboardWillShow(notification:NSNotification){
        if(bottomEditText.isFirstResponder() && view.frame.origin.y == 0.0){
            view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    func keyboardWillDismiss(notification:NSNotification){
        view.frame.origin.y = 0.0
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
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
}

