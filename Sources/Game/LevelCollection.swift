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
      board: Board(
        rows: 2,
        columns: 1,
        spring: DampedHarmonicSpring(dampingRatio: 0.35, frequencyResponse: 0.8)
      ),
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
      board: Board(
        rows: 3,
        columns: 1,
        spring: DampedHarmonicSpring(dampingRatio: 0.45, frequencyResponse: 0.85)
      ),
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (3, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 2
    ),
    Level(
      id: "level_03",
      board: Board(
        rows: 2,
        columns: 2,
        spring: DampedHarmonicSpring(dampingRatio: 0.55, frequencyResponse: 0.9)
      ),
      dragCost: 1,
      wrongPocketCost: 1,
      pocketHistory: [],
      startPocket: (2, 2),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 2
    )]
  }
}
