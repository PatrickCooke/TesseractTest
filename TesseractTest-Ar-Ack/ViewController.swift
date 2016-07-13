//
//  ViewController.swift
//  TesseractTest-Ar-Ack
//
//  Created by Patrick Cooke on 7/12/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, G8TesseractDelegate {
    
    @IBOutlet weak var resultTextView   :UITextView!

    //MARK: - Interaction Methods
    
//    @IBAction func choosePic(sender: AnyObject) {
//        // 2
//        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .ActionSheet)
//        // 3
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//            let cameraButton = UIAlertAction(title: "Take Photo", style: .Default){ (alert) -> Void in
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .Camera
//                self.presentViewController(imagePicker, animated: true, completion: nil)
//            }
//            imagePickerActionSheet.addAction(cameraButton)
//        }
//        // 4
//        let libraryButton = UIAlertAction(title: "Choose Existing",
//                                          style: .Default) { (alert) -> Void in
//                                            let imagePicker = UIImagePickerController()
//                                            imagePicker.delegate = self
//                                            imagePicker.sourceType = .PhotoLibrary
//                                            self.presentViewController(imagePicker,
//                                                                       animated: true, completion: nil)
//        }
//        imagePickerActionSheet.addAction(libraryButton)
//        // 5
//        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
//        }
//        imagePickerActionSheet.addAction(cancelButton)
//        // 6
//        presentViewController(imagePickerActionSheet, animated: true, completion: nil)
//        
//        
//    }
    
   
    
    @IBAction func checkPic() {
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng");
        tesseract.language = "eng";
        tesseract.delegate = self;
        tesseract.charWhitelist = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890";
        tesseract.image = UIImage(named: "test");
        tesseract.recognize();
        
        //NSLog("%@", tesseract.recognizedText);
        resultTextView.text = tesseract.recognizedText
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


