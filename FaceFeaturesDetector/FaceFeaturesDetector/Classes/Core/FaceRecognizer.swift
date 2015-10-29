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
        
        let orientation = convertImageOrientation(image.imageOrientation)
        let featureOptions = [
            CIDetectorEyeBlink: NSNumber(bool: true),
            CIDetectorSmile: NSNumber(bool: true),
            CIDetectorImageOrientation: NSNumber(integer: orientation.rawValue)
        ]
        let detectedFeatures = detector.featuresInImage(CIImage(image: image)!, options: featureOptions)
        faces.appendContentsOf(detectedFeatures.reduce([CIFaceFeature]()) { (var features, current) -> [CIFaceFeature] in
            if let feature = current as? CIFaceFeature {
                features.append(feature)
            }
            
            return features
        })
    }
    
    private func convertImageOrientation(orientation: UIImageOrientation) -> CIImageOrientation {
        switch orientation {
            /// default orientation
        case .Up:
            return .TopLeft
            /// 180 deg rotation
        case .Down:
            return .BottomRight
            // 90 deg CCW
        case .Left:
            return .BottomLeft
            // 90 deg CW
        case .Right:
            return .TopRight
            // as above but image mirrored along other axis. horizontal flip
        case .UpMirrored:
            return .LeftTop
            // horizontal flip
        case .DownMirrored:
            return .RightBottom
            // vertical flip
        case .LeftMirrored:
            return .LeftBottom
            // vertical flip
        case .RightMirrored:
            return .RightTop
        }
    }
    
}