//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

enum GameState {
  case LevelingUp, RetryingLevel, Playing(level: Level), Scored, Missed, Dragging
}

class GameController {
  // MARK: - Properties

  private(set) var totalPoints = 0
  private(set) var level: Level = LevelCollection.levels.first!

  // MARK: - Game state

  var state = GameStateMachine()

  // MARK: - Transitions

  func updateBoardConfig(config: Board) {
    level.board = config
    state.start(level: level)
  }

  func setLevel(_ level: Level) {
    self.level = level
  }
}

// MARK: - Manage points

extension GameController {
  func tallyPoints() {
    totalPoints += level.points - level.costIncurred
  }
}
