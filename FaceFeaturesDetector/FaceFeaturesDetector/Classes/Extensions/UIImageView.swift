//
//  UIImageView.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 27.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private static let screenScale = UIScreen.mainScreen().scale
    
    func convertImageCoordinateSpace(rectInImage rectInImage: CGRect) -> CGRect {
        guard let image = image else {
            fatalError("There is no image")
        }
        let transformedRect = CGRect(x: rectInImage.origin.x, y: image.size.height - rectInImage.origin.y - rectInImage.height, width: rectInImage.width, height: rectInImage.height)
        let scaledRect = transformedRect.scale(1 / UIImageView.screenScale)
        
        let distortion = calculateImageDistortion()
        let offset = calculateImageOffset(distortion)
        
        return CGRect(x: scaledRect.origin.x * distortion.width + offset.x, y: scaledRect.origin.y * distortion.height + offset.y, width: scaledRect.width * distortion.width, height: scaledRect.height * distortion.height)
    }
    
    func convertImageCoordinateSpace(pointInImage pointInImage: CGPoint) -> CGPoint {
        guard let image = image else {
            fatalError("There is no image")
        }
        
        let transformedPoint = CGPoint(x: pointInImage.x, y: image.size.height - pointInImage.y)
        let scaledPoint = transformedPoint.scale(1 / UIImageView.screenScale)
        
        let distortion = calculateImageDistortion()
        let offset = calculateImageOffset(distortion)
        return CGPoint(x: scaledPoint.x * distortion.width + offset.x, y: scaledPoint.y * distortion.height + offset.y)
    }
    
    private func calculateImageDistortion() -> CGSize {
        guard let image = image else {
            fatalError("There is no image")
        }
        
        let xDistortion: CGFloat
        let yDistortion: CGFloat
        switch contentMode {
        case .ScaleToFill:
            xDistortion = bounds.width / image.size.width * UIImageView.screenScale
            yDistortion = bounds.height / image.size.height * UIImageView.screenScale
        case .ScaleAspectFit:
            if image.size.height >= image.size.width {
                yDistortion = bounds.height / image.size.height * UIImageView.screenScale
                xDistortion = yDistortion
            } else {
                xDistortion = bounds.width / image.size.width * UIImageView.screenScale
                yDistortion = xDistortion
            }
        default:
            yDistortion = 1
            xDistortion = 1
        }
        
        return CGSize(width: xDistortion, height: yDistortion)
    }
    
    private func calculateImageOffset(distortion: CGSize) -> CGPoint {
        guard let image = image else {
            fatalError("There is no image")
        }
        
        let convertedImageSize = CGSize(width: image.size.width * distortion.width / UIImageView.screenScale, height: image.size.height * distortion.height / UIImageView.screenScale)
        
        return CGPoint(x: (bounds.width - convertedImageSize.width) / 2, y: (bounds.height - convertedImageSize.height) / 2)
    }
    
}
