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
    
    func transformPointFromCoreImageAxes(var point: CGPoint, toView: Bool = true) -> CGPoint {
        point.y = (toView ? faceView.bounds.height : faceView.image!.size.height) - point.y
        
        return point
    }
    
    func transformRectFromCoreImageAxes(var rect: CGRect, toView: Bool = true) -> CGRect {
        rect.origin.y = (toView ? faceView.bounds.height : faceView.image!.size.height) - rect.origin.y - rect.height
        
        return rect
    }
    
    func convertToVisiblePointFromCoreImageAxes(point: CGPoint) -> CGPoint {
        let convertedPoint = faceView.convertPointFromImage(point)
        
        return transformPointFromCoreImageAxes(convertedPoint)
    }
    
    func convertToVisibleRectFromCoreImageAxes(rect: CGRect) -> CGRect {
        let convertedRect = faceView.convertRectFromImage(rect)
        
        return transformRectFromCoreImageAxes(convertedRect)
    }
    
}
