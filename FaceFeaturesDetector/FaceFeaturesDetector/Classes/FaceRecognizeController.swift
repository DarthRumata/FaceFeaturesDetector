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
                let convertedRect = photoView.convertImageCoordinateSpace(rectInImage: face.bounds)
                print("converted: \(convertedRect)")
                
                markFace(convertedRect)
                markEyes([face.leftEyePosition, face.rightEyePosition])
            }
        }
    }
    
    private func markEyes(positions: [CGPoint]) {
        let convertedPositions = positions.map { point -> CGPoint in
            return photoView.convertImageCoordinateSpace(pointInImage: point)
        }
        let eyeDistance = GeometryHelper.distance(convertedPositions[0], second: convertedPositions[1])
        let eyeSize = CGSize(width: eyeDistance * 0.7, height: eyeDistance * 0.35)
        for position in convertedPositions {
            let eyeRect = CGRect(x: position.x - eyeSize.width / 2, y: position.y - eyeSize.height / 2, width: eyeSize.width, height: eyeSize.height)
            let eyeLayer = CAShapeLayer()
            eyeLayer.fillColor = UIColor.blueColor().CGColor
            eyeLayer.path = UIBezierPath(ovalInRect: eyeRect).CGPath
            photoView.layer.addSublayer(eyeLayer)
            markers.append(eyeLayer)
        }
    }
    
    private func markFace(bounds: CGRect) {
        let boundLayer = CAShapeLayer()
        boundLayer.path = UIBezierPath(rect: bounds).CGPath
        boundLayer.strokeColor = UIColor.redColor().CGColor
        boundLayer.fillColor = UIColor.clearColor().CGColor
        photoView.layer.addSublayer(boundLayer)
        markers.append(boundLayer)
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

