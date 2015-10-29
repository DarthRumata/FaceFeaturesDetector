//
//  GeometryHelper.swift
//  FaceFeaturesDetector
//
//  Created by Stas Kirichok on 29.10.15.
//  Copyright © 2015 Stas Kirichok. All rights reserved.
//

import UIKit

final class GeometryHelper {
    
    static func distance(first: CGPoint, second: CGPoint) -> CGFloat {
        return sqrt(pow(first.x - second.x, 2) + pow(first.y - second.y, 2))
    }
    
}
