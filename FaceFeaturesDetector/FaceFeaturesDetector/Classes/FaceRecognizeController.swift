//
//  ViewController.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 27.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit
import ImageIO

private let spectrumEdgeSize: CGFloat = 30
private let spectrumOffset: CGFloat = 5

class FaceRecognizeController: UIViewController {
    
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet weak var leftEye: UIImageView!
    @IBOutlet weak var rightEye: UIImageView!
    
    private lazy var marker: FaceMarker = FaceMarker(faceView: self.photoView)
    private lazy var faceRecognizer: FaceRecognizer = FaceRecognizer(faceView: self.photoView)
    private var eyes: [Eye]!
    
    private var spectrumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var recognizer = UITapGestureRecognizer(target: self, action: Selector("tapLeftEye"))
        leftEye.addGestureRecognizer(recognizer)
        recognizer = UITapGestureRecognizer(target: self, action: Selector("tapRightEye"))
        rightEye.addGestureRecognizer(recognizer)
    }
    
    //MARK: UI
    func tapLeftEye() {
        showColorSpectrum(eyes[0].colors)
    }
    
    func tapRightEye() {
        showColorSpectrum(eyes[1].colors)
    }
    
    private func showColorSpectrum(colors: [CGColor]) {
        if spectrumView != nil {
            spectrumView.removeFromSuperview()
            spectrumView = nil
        }
        
        let columns: CGFloat = 3
        let rows = ceil(CGFloat(colors.count) / columns)
        let spectrumSize = CGSize(
            width: columns * spectrumEdgeSize + (columns - 1) * spectrumOffset,
            height: rows * spectrumEdgeSize + (rows - 1) * spectrumOffset
        )
        let spectrumCenter = CGPoint(x: view.center.x, y: view.center.y + 100)
        let frame = CGRect.create(spectrumCenter, size: spectrumSize)
        spectrumView = UIView(frame: frame)
        for row in 0..<Int(rows) {
            for column in 0..<Int(columns) {
                let colorIndex = row * Int(columns) + column
                if colorIndex >= colors.count {
                    break
                }
                
                let frame = CGRect(
                    x: CGFloat(column) * (spectrumEdgeSize + spectrumOffset),
                    y: CGFloat(row) * (spectrumEdgeSize + spectrumOffset),
                    width: spectrumEdgeSize,
                    height: spectrumEdgeSize
                )
                let spectrumItemView = UIView(frame: frame)
                
                spectrumItemView.backgroundColor = UIColor(CGColor: colors[colorIndex])
                spectrumView.addSubview(spectrumItemView)
            }
        }
        
        view.addSubview(spectrumView)
    }
    
    //MARK: Actions
    @IBAction func chooseImage() {
        getNewImage(.PhotoLibrary)
    }
    
    @IBAction func takePhoto() {
        getNewImage(.Camera)
    }
    
    @IBAction func recognize() {
        marker.removeAllMarks()
        faceRecognizer.recognize()
        
        guard !faceRecognizer.faces.isEmpty else {
            print("Recognition failed")
            return
        }
        
        for face in faceRecognizer.faces {
            marker.markFace(face.bounds)
            
            marker.markEyes(face)
            if let eyes = faceRecognizer.detectEyesColor(face) {
                leftEye.image = eyes.first?.image
                rightEye.image = eyes.last?.image
                self.eyes = eyes
            }
        }
    }
    
    //MARK: Processing
    private func getNewImage(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
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

