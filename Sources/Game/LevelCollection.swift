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
      wrongPocketCost: 10,
      pocketHistory: [],
      startPocket: (2, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 100,
      backgroundLight: "water.fsh",
      backgroundDark: "purple_lights.fsh"
    ),
    Level(
      id: "level_02",
      board: Board(
        rows: 3,
        columns: 1,
        spring: DampedHarmonicSpring(dampingRatio: 0.45, frequencyResponse: 0.85)
      ),
      dragCost: 2,
      wrongPocketCost: 20,
      pocketHistory: [],
      startPocket: (3, 1),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 200,
      backgroundLight: "lines.fsh",
      backgroundDark: "beehive.fsh"
    ),
    Level(
      id: "level_03",
      board: Board(
        rows: 2,
        columns: 2,
        spring: DampedHarmonicSpring(dampingRatio: 0.55, frequencyResponse: 0.9)
      ),
      dragCost: 3,
      wrongPocketCost: 30,
      pocketHistory: [],
      startPocket: (2, 2),
      endPocket: (1, 1),
      costIncurred: 0,
      points: 300,
      backgroundLight: "wormhole.fsh",
      backgroundDark: "glass.fsh"
    ),
     Level(
       id: "level_04",
       board: Board(
         rows: 3,
         columns: 3,
         spring: DampedHarmonicSpring(dampingRatio: 0.65, frequencyResponse: 0.925)
       ),
       dragCost: 4,
       wrongPocketCost: 40,
       pocketHistory: [],
       startPocket: (3, 3),
       endPocket: (2, 2),
       costIncurred: 0,
       points: 300,
       backgroundLight: "water.fsh",
       backgroundDark: "purple_lights.fsh"
     ),
     Level(
       id: "level_05",
       board: Board(
         rows: 4,
         columns: 3,
         spring: DampedHarmonicSpring(dampingRatio: 0.75, frequencyResponse: 0.95)
       ),
       dragCost: 5,
       wrongPocketCost: 50,
       pocketHistory: [],
       startPocket: (4, 3),
       endPocket: (2, 3),
       costIncurred: 0,
       points: 400,
       backgroundLight: "lines.fsh",
       backgroundDark: "beehive.fsh"
     )]
  }
}
