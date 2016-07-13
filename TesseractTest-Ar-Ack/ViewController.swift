//
//  ViewController.swift
//  TesseractTest-Ar-Ack
//
//  Created by Patrick Cooke on 7/12/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    @IBOutlet weak var resultTextView   :UITextView!
    var activityIndicator:UIActivityIndicatorView!

    //MARK: - Interaction Methods
    
    @IBAction func choosePic(sender: AnyObject) {
        // 2
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .ActionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .Default){ (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .Default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .PhotoLibrary
                                            self.presentViewController(imagePicker,
                                                                       animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        presentViewController(imagePickerActionSheet, animated: true, completion: nil)
        
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let selectedPhoto = editingInfo![UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismissViewControllerAnimated(true) {
            self.checkPic(scaledImage)
        }
    }
    
   
    
    func checkPic(image: UIImage) {
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng");
        tesseract.language = "eng";
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.delegate = self;
        //tesseract.charWhitelist = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890";
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize();
        
        resultTextView.text = tesseract.recognizedText
        
        removeActivityIndicator()
    }
    
    // Activity Indicator methods
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismissViewControllerAnimated(true, completion: {
            self.checkPic(scaledImage)
        })
    }
}
