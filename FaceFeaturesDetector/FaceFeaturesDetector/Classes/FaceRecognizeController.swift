//
//  ViewController.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 27.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit
import ImageIO

class FaceRecognizeController: UIViewController {
    
    @IBOutlet private weak var photoView: UIImageView!
    
    private lazy var marker: FaceMarker = FaceMarker(faceView: self.photoView)
    private let faceRecognizer = FaceRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func chooseImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func recognize() {
        guard let image = photoView.image else {
            print("no image")
            return
        }
        
        marker.removeAllMarks()
        faceRecognizer.recognize(image)
        
        guard !faceRecognizer.faces.isEmpty else {
            print("Recognition failed")
            return
        }
        
        for face in faceRecognizer.faces {
            let convertedRect = photoView.convertImageCoordinateSpace(rectInImage: face.bounds)
            
            marker.markFace(convertedRect)
            marker.markEyes([face.leftEyePosition, face.rightEyePosition])
        }
    }
    
}

extension FaceRecognizeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        marker.removeAllMarks()
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoView.image = chosenImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

