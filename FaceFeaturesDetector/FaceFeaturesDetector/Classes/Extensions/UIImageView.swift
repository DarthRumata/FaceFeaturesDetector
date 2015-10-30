//
//  UIImageView.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 27.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func convertPointFromImage(var imagePoint: CGPoint) -> CGPoint {
        guard let image = image else {
            fatalError("There is no image")
        }
        
        let imageSize = image.size
        let viewSize  = bounds.size
        
        let ratioX = viewSize.width / imageSize.width;
        let ratioY = viewSize.height / imageSize.height;
        
        switch contentMode {
        case .ScaleToFill:
            fallthrough
        case .Redraw:
            imagePoint.x *= ratioX
            imagePoint.y *= ratioY
            
        case .ScaleAspectFit:
            fallthrough
        case .ScaleAspectFill:
            let scale = contentMode == .ScaleAspectFit ? min(ratioX, ratioY) : max(ratioX, ratioY)
            
            imagePoint.x *= scale;
            imagePoint.y *= scale;
            
            imagePoint.x += (viewSize.width  - imageSize.width  * scale) / 2
            imagePoint.y += (viewSize.height - imageSize.height * scale) / 2
            
        case .Center:
            imagePoint.x += viewSize.width / 2  - imageSize.width  / 2
            imagePoint.y += viewSize.height / 2 - imageSize.height / 2
            
        case .Top:
            imagePoint.x += viewSize.width / 2 - imageSize.width / 2
            
        case .Bottom:
            imagePoint.x += viewSize.width / 2 - imageSize.width / 2
            imagePoint.y += viewSize.height - imageSize.height
            
        case .Left:
            imagePoint.y += viewSize.height / 2 - imageSize.height / 2
            
        case .Right:
            imagePoint.x += viewSize.width - imageSize.width
            imagePoint.y += viewSize.height / 2 - imageSize.height / 2
            
        case .TopRight:
            imagePoint.x += viewSize.width - imageSize.width;
            
        case .BottomLeft:
            imagePoint.y += viewSize.height - imageSize.height;
            
            
        case .BottomRight:
            imagePoint.x += viewSize.width  - imageSize.width;
            imagePoint.y += viewSize.height - imageSize.height;
            
        default:
            break
        }
        
        return imagePoint;
    }
    
    func convertRectFromImage(imageRect: CGRect) -> CGRect {
        let imageTopLeft = imageRect.origin;
        let imageBottomRight = CGPointMake(CGRectGetMaxX(imageRect),
            CGRectGetMaxY(imageRect));
        
        let viewTopLeft = convertPointFromImage(imageTopLeft)
        let viewBottomRight = convertPointFromImage(imageBottomRight)
        
        let origin = viewTopLeft;
        let size = CGSize(
            width: abs(viewBottomRight.x - viewTopLeft.x),
            height: abs(viewBottomRight.y - viewTopLeft.y)
        )
        
        return CGRect(origin: origin, size: size)
    }
    
}
