//
//  UIColor+Extensions.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 05/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation
import UIKit

/// Extension for random value get.
extension CGFloat {
    static func randomValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
/// Extension for random color using random value.
extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
           red:   .randomValue(),
           green: .randomValue(),
           blue:  .randomValue(),
           alpha: 1.0
        )
    }
}
