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
    
    private lazy var markers = [CALayer]()
    
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
        guard let image = photoView.image, ciImage = CIImage(image: image) else {
            print("no image")
            return
        }
        
        let context = CIContext()
        let options: [String: AnyObject] = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        for feature in detector.featuresInImage(ciImage) {
            if let face = feature as? CIFaceFeature {
                print(face.bounds)
                let convertedRect = photoView.convertImageCoordinatesRect(face.bounds)
                print("converted: \(convertedRect)")
                
                let boundLayer = CAShapeLayer()
                boundLayer.path = UIBezierPath(rect: convertedRect).CGPath
                boundLayer.strokeColor = UIColor.redColor().CGColor
                boundLayer.fillColor = UIColor.clearColor().CGColor
                photoView.layer.addSublayer(boundLayer)
                markers.append(boundLayer)
            }
        }
    }
    
    private func cleanPhoto() {
        for marker in markers {
            marker.removeFromSuperlayer()
        }
        markers.removeAll()
    }
}

extension FaceRecognizeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        cleanPhoto()
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoView.image = chosenImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

