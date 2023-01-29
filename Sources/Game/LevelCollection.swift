//
//  LevelCollection.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

enum LevelCollection {
  static var levels: [Level] {
    [Level(
      board: boards.first!,
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (2, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 1
    )]
  }

  static let boards: [Board] = [
    Board(id: "board_01",
          rows: 2,
          columns: 1,
          spring: DampedHarmonicSpring(dampingRatio: 0.35, frequencyResponse: 0.8))
  ]
}
