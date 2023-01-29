//
//  App.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 24/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation

class App {
  static let shared = App()
  var gameState = GameState()
  private init() {}
}

struct Boards {}
