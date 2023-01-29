//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Combine

// MARK: - This state machine manages the progress of the game and publiishes updates to view.

class GameState : ObservableObject {
  private(set) var totalPoints = 0
  private(set) var levelPoints = 100
  private(set) var currentLevel = levels.first!

  // State
  private var userState: UserState = .Start
  private enum UserState {
    case Start, Scored, Missed, Dragging
  }

  private enum LevelState {
    case LevelUp, RetryLevel
  }

  // State management
  func updateBoard(config: Board) {
    currentLevel.board = config
    currentLevel.startPocket = (1,1)
    objectWillChange.send()
  }

  // Levels
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
