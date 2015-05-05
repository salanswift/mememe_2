//
//  ViewController.swift
//  MEME me
//
//  Created by Arsalan Akhtar on 20/04/2015.
//  Copyright (c) 2015 Arsalan Akhtar. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var sendMemeActionButton: UIBarButtonItem!

    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    @IBOutlet weak var topNavBar: UINavigationBar!
  
   
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    @IBAction func cancelEditingMeme(sender: AnyObject)
    {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let defaultTextFieldText:String = "Enter your text here"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.lightGrayColor(),
        NSForegroundColorAttributeName :UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName :-5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting of text attributes to meme text fields top and bottom
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //Aligning text to centre
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        //Setting Default Text
        topTextField.text = defaultTextFieldText
        bottomTextField.text = defaultTextFieldText
        
        // Keeping action button disabled so the meme cannot be sent until the image is not supplied by the user
        sendMemeActionButton.enabled = false
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        self.subscribeToHideKeyboardNotifications()
        
        //it will enable the camerabutton only when the camera is available on the device otherwise it will disable it
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    
@IBAction func sendMeme(sender: AnyObject)
    {
        let memedImg : UIImage = generateMemedImage()
        var controller = UIActivityViewController(activityItems: [memedImg], applicationActivities: nil)
        
        //Completion handler will be called once the activity has successfully has sent the meme
        
        controller.completionWithItemsHandler = (
            {
            (activityType, completed:Bool , items, error) in
                if completed
                {
                    self.saveMeme(memedImg)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        })
            self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func saveMeme(memedImg:UIImage)
    {
        var meme = Meme( topfield: self.topTextField.text!, bottomField:self.bottomTextField.text, imageView:self.memeImageView.image!, memed: memedImg)
        (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes.append(meme)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    

    func subscribeToHideKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder()
        {
            //it will move up the view by the height of the keyboard
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {

            //it will bring back the view to its orignal position
            self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        //returns the height of the keyboard
    
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func pickImageFromLibrary(sender: AnyObject)
    {
        //opens the image library
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageFromCamera(sender: AnyObject)
    {
        //opens the camera to take the image
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            memeImageView.image = image
            
             // enable action button here so the meme can only be generated and sent once the image view is filled with image
            sendMemeActionButton.enabled = true
            topNavBar.hidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Textfields
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        if (textField.text == defaultTextFieldText)
        {
         textField.text = ""
            
        }
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool
    {  //delegate method
        
        if (textField.text == "")
        {
            textField.text = defaultTextFieldText
            
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func generateMemedImage() -> UIImage {
        //  Hide toolbar and navbar
        bottomToolBar.hidden = true
        topNavBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        bottomToolBar.hidden = false
        topNavBar.hidden = false
        
        return memedImage
    }
}