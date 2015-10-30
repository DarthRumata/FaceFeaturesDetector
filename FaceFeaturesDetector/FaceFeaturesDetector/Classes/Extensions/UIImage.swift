//
//  UIImage.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 30.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension UIImage {
    
    func normalOrientedImage() -> UIImage {
        var transform = CGAffineTransformIdentity
        switch imageOrientation {
        case .Down:
            fallthrough
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left:
            fallthrough
        case .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right:
            fallthrough
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        default:
            break
        }
        
        switch imageOrientation {
        case .UpMirrored:
            fallthrough
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1);
        case .LeftMirrored:
            fallthrough
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGBitmapContextCreate(nil, Int(size.width), Int(size.height),
            CGImageGetBitsPerComponent(CGImage), 0,
            CGImageGetColorSpace(CGImage),
            CGImageGetBitmapInfo(CGImage).rawValue
        )
        CGContextConcatCTM(ctx, transform)
        switch imageOrientation {
        case .Left:
            fallthrough
        case .LeftMirrored:
            fallthrough
        case .Right:
            fallthrough
        case .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.height, size.width), CGImage)
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.width, size.height), CGImage)
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgImage = CGBitmapContextCreateImage(ctx)!
        let img = UIImage(CGImage: cgImage)
        
        return img
    }
    
}