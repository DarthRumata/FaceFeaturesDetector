//
//  CGRect.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension CGRect {
    
    var center: CGPoint {
        let x = origin.x + width / 2
        let y = origin.y + height / 2
        return CGPoint(x: x, y: y)
    }
    
    func scale(scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, y: origin.y * scale, width: width * scale, height: height * scale)
    }
    
}
