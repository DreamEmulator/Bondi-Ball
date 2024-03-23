//
//  Sounds.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 11/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation

enum Sounds: String {
  case scoredSound = "scored"
  case missedSound = "missed"
  case failedSound = "failed"
  case touchedSound = "touched"
  case flickedSound = "flicked"

  var url: URL {
    Bundle.main.url(forResource: self.rawValue, withExtension: "m4a")!
  }
}
