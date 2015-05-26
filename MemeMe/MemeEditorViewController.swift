//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Eric Winn on 5/22/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navToolbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // MARK: - Setup
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = false
        
        topText.delegate = self
        bottomText.delegate = self
    }
    
    // MARK: - Keyboard notification and text defaults
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setTextFieldDefaults(topText, tag: 0, placeholder: "TOP", textAttributes: memeTextAttributes)
        setTextFieldDefaults(bottomText, tag: 1, placeholder: "BOTTOM", textAttributes: memeTextAttributes)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: - Image picker functions
    // Uses a popover on iPads and Landscape iPhone 6P, otherwise fullscreen on smaller devices
    @IBAction func pickAnImageFromLibrary(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = false
        pickerController.sourceType = .PhotoLibrary
        pickerController.modalPresentationStyle = .Popover
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
        pickerController.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = false
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.cameraCaptureMode = .Photo
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.contentMode = .ScaleAspectFit
            memeImage.image = chosenImage
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - textField functions
    func setTextFieldDefaults(textField: UITextField, tag: Int, placeholder: String, textAttributes: [NSObject: AnyObject]) -> Bool {
        // NOTE: autocapitalizationType only works with the device software keyboard but
        // external keyboards will not. Using shouldChangeCharactersInRange delegate method instead.
        textField.tag = tag
        textField.defaultTextAttributes = textAttributes
        if textField.text == "" {
            textField.text = placeholder
        }
        textField.borderStyle = .None
        textField.textAlignment = .Center
        textField.backgroundColor = nil
        textField.minimumFontSize = 15.0
        textField.adjustsFontSizeToFitWidth = true
        return true
    }
    
    // NOTE: - Inserting into the middle of the string pops the cursor to the end of the current string (makes no difference for return ? true ; false)
    // ATTRIB: - http://discussions.udacity.com/t/lesson-3-the-uitextfielddelegate-protocol/10292/25
    // ATTRIB: - http://stackoverflow.com/a/13388037
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Prevent undo crash
        if range.location + range.length > (textField.text as NSString).length {
            return false
        }
        
        // Force entry to uppercase
        let lowercaseCharacters = NSCharacterSet.lowercaseLetterCharacterSet()
        
        if let lowercaseRange = string.rangeOfCharacterFromSet(lowercaseCharacters) {
            let uppercaseString = string.uppercaseString
            if textField.text.isEmpty {
                // Updates return button; forces cursor to the end
                textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: uppercaseString)
            } else {
                // Preserves cursor location; doesn't update return button
                let beginning = textField.beginningOfDocument
                let start = textField.positionFromPosition(beginning, offset: range.location)!
                let end = textField.positionFromPosition(start, offset: range.length)!
                let range = textField.textRangeFromPosition(start, toPosition: end)
                textField.replaceRange(range, withText: uppercaseString)
            }
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text.isEmpty && textField.tag == 0 {
            textField.text = "TOP"
        } else if textField.text.isEmpty && textField.tag == 1 {
            textField.text = "BOTTOM"
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Share and save meme functions
    // Uses a popover on iPads and Landscape iPhone 6P, otherwise fullscreen on smaller devices
    // ATTRIB: - Special thanks to Gene De Lisa who's blog and demo helped me understand this better
    // ref: - http://www.rockhoppertech.com/blog/uiactivitycontroller-in-swift/
    // ref: - https://github.com/genedelisa/ActivityDemo/blob/master/ActivityDemo/ViewController.swift
    func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let avc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // construct the avc completion handler
        avc.completionWithItemsHandler = { (activity, completed, items, error) in
            if !completed {
                return
            } else {
                // save the meme
                self.save()
                // Done with MemeEdit VC, return to Sent Memes VC
                self.goBack()
            }
        }
        // Disable sending to printer
        avc.excludedActivityTypes = [UIActivityTypePrint]
    
        // show the Share Activity Controller choices and wait for user input
        self.presentViewController(avc, animated: true, completion: nil)
        avc.popoverPresentationController?.barButtonItem = sender
    }
    
    func generateMemedImage() -> UIImage {
        navToolbar.hidden = true
        bottomToolbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navToolbar.hidden = false
        bottomToolbar.hidden = false
        return memedImage
    }
    
    func save() {
        let image = generateMemedImage()
        var meme = Meme(top: topText.text!, bottom: bottomText.text!, image: memeImage.image!, memedImage: image)
        // Add to memes array
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        applicationDelegate.memes.append(meme)
    }

    
    // MARK: - Cancel Meme Editor VC
    @IBAction func cancelMemeEdit(sender: AnyObject) {
        self.goBack()
    }
    
    // MARK: - Utility functions
    func goBack() {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as? UITabBarController {
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            println("Something is broken...")
        }
    }
}
