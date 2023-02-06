//
//  UINib+Extensions.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

extension UINib {
  @propertyWrapper private struct Named {
    let wrappedValue: UINib

    init(_ name: String, in bundle: Bundle = .main) {
      wrappedValue = UIKit.UINib(nibName: name, bundle: bundle)
    }
  }

  @Named("Game") static var game

  func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> UIView? {
    instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIView
  }
}
