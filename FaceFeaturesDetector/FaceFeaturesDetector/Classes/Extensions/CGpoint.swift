//
//  CGpoint.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func scale(scale: CGFloat) -> CGPoint {
        return CGPoint(x: x * scale, y: y * scale)
    }
    
}