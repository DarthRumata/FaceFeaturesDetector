//
//  UIImageView.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 27.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func convertImageCoordinatesRect(rectInImage: CGRect) -> CGRect {
        guard let image = image else {
            fatalError("There is no image")
        }
        let transformedRect = CGRect(x: rectInImage.origin.x, y: image.size.height - rectInImage.origin.y - rectInImage.height, width: rectInImage.width, height: rectInImage.height)
        print("transformed: \(transformedRect)")
        
        let scale: CGFloat = UIScreen.mainScreen().scale
        let scaledRect = CGRect(x: transformedRect.origin.x / scale, y: transformedRect.origin.y / scale, width: transformedRect.width / scale, height: transformedRect.height / scale)
        print("scaled: \(scaledRect)")
        
        
        
        let xDistortion: CGFloat
        let yDistortion: CGFloat
        switch contentMode {
        case .ScaleToFill:
            xDistortion = bounds.width / image.size.width * scale
            yDistortion = bounds.height / image.size.height * scale
        case .ScaleAspectFit:
            if image.size.height >= image.size.width {
               yDistortion = bounds.height / image.size.height * scale
               xDistortion = yDistortion
            } else {
                xDistortion = bounds.width / image.size.width * scale
                yDistortion = xDistortion
            }
        default:
            yDistortion = 1
            xDistortion = 1
        }
        
        return CGRect(x: scaledRect.origin.x * xDistortion, y: scaledRect.origin.y * yDistortion, width: scaledRect.width * xDistortion, height: scaledRect.height * yDistortion)
    }
    
}
