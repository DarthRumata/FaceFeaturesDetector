//
//  FaceMarker.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

class FaceMarker {
    
    private lazy var marks = [CALayer]()
    private let faceView: UIImageView
    
    init(faceView: UIImageView) {
        self.faceView = faceView
    }
    
    func markFace(bounds: CGRect) {
        var convertedRect = faceView.convertRectFromImage(bounds)
        convertedRect.origin.y = faceView.bounds.height - convertedRect.origin.y - convertedRect.height
        
        let boundLayer = CAShapeLayer()
        boundLayer.path = UIBezierPath(rect: convertedRect).CGPath
        boundLayer.strokeColor = UIColor.redColor().CGColor
        boundLayer.fillColor = UIColor.clearColor().CGColor
        faceView.layer.addSublayer(boundLayer)
        marks.append(boundLayer)
    }
    
    func markEyes(positions: [CGPoint]) {
        let convertedPositions = positions.map { point -> CGPoint in
            var convertedPoint = faceView.convertPointFromImage(point)
            convertedPoint.y = faceView.bounds.height - convertedPoint.y
            return convertedPoint
        }
        let eyeDistance = GeometryHelper.distance(convertedPositions[0], second: convertedPositions[1])
        let eyeSize = CGSize(width: eyeDistance * 0.7, height: eyeDistance * 0.35)
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