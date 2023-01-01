//
//  UIButton+Extensions.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 01/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  enum customStyle {
    case alpha
  }
  convenience init(_ style: UIButton.customStyle) {
    self.init()
    print("Init Ain't it?")
  }
}
