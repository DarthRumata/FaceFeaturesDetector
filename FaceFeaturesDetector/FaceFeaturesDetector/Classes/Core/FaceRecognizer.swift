//
//  FaceRecognizer.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

private enum CIImageOrientation: Int {
    case TopLeft = 1
    case TopRight = 2
    case BottomRight = 3
    case BottomLeft = 4
    case LeftTop = 5
    case RightTop = 6
    case RightBottom = 7
    case LeftBottom = 8
}

private let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]

class FaceRecognizer: FaceViewProcessor {
    
    private lazy var detector = CIDetector(ofType: CIDetectorTypeFace, context: CIContext(), options: detectorOptions)
    
    private(set) lazy var faces = [CIFaceFeature]()
    
    func recognize() {
        guard let image = faceView.image else {
            print("no image")
            return
        }
        
        faces.removeAll()
        
        let normalizedImage = image.normalOrientedImage()
        let featureOptions = [
            CIDetectorEyeBlink: NSNumber(bool: true),
            CIDetectorSmile: NSNumber(bool: true),
        ]
        faces = detector.featuresInImage(CIImage(image: normalizedImage)!, options: featureOptions) as! [CIFaceFeature]
    }
    
    func detectEyesColor(face: CIFaceFeature) -> [Eye]? {
        guard let image = faceView.image?.normalOrientedImage() else {
            print("no image")
            return nil
        }
        
        var eyes = [Eye]()
        
        var eyePositions = [CGPoint]()
        if face.hasLeftEyePosition {
            eyePositions.append(face.leftEyePosition)
        }
        if face.hasRightEyePosition {
            eyePositions.append(face.rightEyePosition)
        }
        let transformedPositions = eyePositions.map { point -> CGPoint in
            return transformPointFromCoreImageAxes(point, toView: false)
        }
        let transformedBounds = transformRectFromCoreImageAxes(face.bounds, toView: false)
        let eyeSize = CGSize(width: transformedBounds.width * 0.14, height: transformedBounds.width * 0.08)
        
        for eye in transformedPositions {
            let frame = CGRect.create(eye, size: eyeSize)
            let eyeImage = image.cropRect(frame)
            
            let colors = dominantColorsInImage(eyeImage.CGImage!)
            eyes.append(Eye(image: eyeImage, colors: colors))
            print(colors)
        }
        
        return eyes
    }
    
}