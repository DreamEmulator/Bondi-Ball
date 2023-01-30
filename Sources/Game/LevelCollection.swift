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
      id: "level_01",
      board: boards[0],
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (2, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 1
    ),
    Level(
      id: "level_02",
      board: boards[1],
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (2, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 2
    )]
  }

  static let boards: [Board] = [
    Board(id: "board_01",
          rows: 2,
          columns: 1,
          spring: DampedHarmonicSpring(dampingRatio: 0.35, frequencyResponse: 0.8)),
    Board(id: "board_02",
          rows: 3,
          columns: 1,
          spring: DampedHarmonicSpring(dampingRatio: 0.65, frequencyResponse: 0.2))
  ]
}
