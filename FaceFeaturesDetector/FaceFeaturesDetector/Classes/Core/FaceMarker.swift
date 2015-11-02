//
//  FaceMarker.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

class FaceMarker: FaceViewProcessor {
    
    private lazy var marks = [CALayer]()
    
    func markFace(bounds: CGRect) {
        let convertedRect = convertRectFromCoreImageAxes(bounds)
        
        let boundLayer = CAShapeLayer()
        boundLayer.path = UIBezierPath(rect: convertedRect).CGPath
        boundLayer.strokeColor = UIColor.redColor().CGColor
        boundLayer.fillColor = UIColor.clearColor().CGColor
        faceView.layer.addSublayer(boundLayer)
        marks.append(boundLayer)
    }
    
    func markEyes(face: CIFaceFeature) {
        var eyes = [CGPoint]()
        if face.hasLeftEyePosition {
            eyes.append(face.leftEyePosition)
        }
        if face.hasRightEyePosition {
            eyes.append(face.rightEyePosition)
        }
        let convertedBounds = convertRectFromCoreImageAxes(face.bounds)
        let eyeSize = CGSize(width: convertedBounds.width * 0.25, height: convertedBounds.width * 0.13)
        
        let convertedPositions = eyes.map { point -> CGPoint in
            return convertPointFromCoreImageAxes(point)
        }
        for position in convertedPositions {
            let eyeRect = CGRect(x: position.x - eyeSize.width / 2, y: position.y - eyeSize.height / 2, width: eyeSize.width, height: eyeSize.height)
            let eyeLayer = CAShapeLayer()
            eyeLayer.fillColor = UIColor.blueColor().CGColor
            eyeLayer.path = UIBezierPath(ovalInRect: eyeRect).CGPath
            faceView.layer.addSublayer(eyeLayer)
            marks.append(eyeLayer)
        }
    }
    
    func removeAllMarks() {
        for marker in marks {
            marker.removeFromSuperlayer()
        }
        marks.removeAll()
    }
    
}