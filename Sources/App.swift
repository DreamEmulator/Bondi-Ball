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

  var game: Game {
    Game(levels: [],
         currentLevel: levels.first!,
         totalPoints: 0,
         badges: [])
  }

  var levels: [Level] {
    [Level(
      board: boards.first!,
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (1, 1),
      endPocket: (0, 1),
      costIncurred: 0,
      points: 1
    )]
  }

  let boards: [Board] = [
    Board(id: UUID(),
          rows: 2,
          columns: 1,
          spring: DampedHarmonicSpring(dampingRatio: 0.1, frequencyResponse: 0.1))
  ]

  private init() {}
}

struct Boards {}
