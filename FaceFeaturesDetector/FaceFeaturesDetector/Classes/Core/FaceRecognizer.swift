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

class FaceRecognizer {
    
    private(set) lazy var faces = [CIFaceFeature]()
    private lazy var detector = CIDetector(ofType: CIDetectorTypeFace, context: CIContext(), options: detectorOptions)
    
    func recognize(image: UIImage) {
        faces.removeAll()
        
        let normalizedImage = image.normalOrientedImage()
        let featureOptions = [
            CIDetectorEyeBlink: NSNumber(bool: true),
            CIDetectorSmile: NSNumber(bool: true),
        ]
        let detectedFeatures = detector.featuresInImage(CIImage(image: normalizedImage)!, options: featureOptions)
        faces.appendContentsOf(detectedFeatures.reduce([CIFaceFeature]()) { (var features, current) -> [CIFaceFeature] in
            if let feature = current as? CIFaceFeature {
                features.append(feature)
            }
            
            return features
        })
    }
    
   
    
}