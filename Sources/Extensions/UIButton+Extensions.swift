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
  enum CustomStyle {
    case alpha
  }

  convenience init(style: UIButton.CustomStyle) {
    self.init()
    self.configure(style: style)
  }

  func configure(style: CustomStyle){
    translatesAutoresizingMaskIntoConstraints = false

    switch style {
    case .alpha:
      if #available(iOS 13.0, *) {
        self.setBackgroundImage( UIImage(systemName: "theatermask.and.paintbrush.fill"), for: .normal)
      } else {
        self.setTitle("Setup", for: .normal)
      }
    }
  }
}
