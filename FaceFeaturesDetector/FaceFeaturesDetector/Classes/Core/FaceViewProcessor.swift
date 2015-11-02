//
//  FaceViewProcessor.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 30.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class FaceViewProcessor {
    
    let faceView: UIImageView
    
    init(faceView: UIImageView) {
        self.faceView = faceView
    }
    
    func convertRectFromCoreImageAxes(rect: CGRect) -> CGRect {
        var convertedRect = faceView.convertRectFromImage(rect)
        convertedRect.origin.y = faceView.bounds.height - convertedRect.origin.y - convertedRect.height
        
        return convertedRect
    }
    
    func convertPointFromCoreImageAxes(point: CGPoint) -> CGPoint {
        var convertedPoint = faceView.convertPointFromImage(point)
        convertedPoint.y = faceView.bounds.height - convertedPoint.y
        
        return convertedPoint
    }
    
}
