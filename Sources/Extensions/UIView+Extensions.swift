//
//  UIView+Extensions.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 06/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit
extension UIView {
  // MARK: - Border styling

  /// Make it possible to add a borderRadius in StoryBoards
  @IBInspectable var cornerRadiusV: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

  /// Make it possible to add a border in StoryBoards
  @IBInspectable var borderWidthV: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColorV: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
}
