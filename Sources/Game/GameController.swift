//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

enum GameState {
  case LevelingUp, RetryingLevel, Playing, Scored, Missed, Dragging
}

class GameController {
  // MARK: - Properties

  private(set) var totalPoints = 0
  private(set) var level: Level = LevelCollection.levels.first!

  // MARK: - Game state

  var state = GameStateMachine()

  init() {
    subscribe()
  }
}

// MARK: Subscriptions

extension GameController {
  func subscribe() {
    state.subscribe { state in
      switch state {
      case .Scored:
        self.totalPoints += App.shared.game.level.points - App.shared.game.level.costIncurred
      case .LevelingUp:

        let currentLevelIndex = LevelCollection.levels.firstIndex(where: { level in
          level.id == App.shared.game.level.id
        })!

        guard currentLevelIndex + 1 < LevelCollection.levels.count else {
          self.level = LevelCollection.levels[currentLevelIndex]
          print("😃 We need more levels!")
          break
        }

        self.level = LevelCollection.levels[currentLevelIndex + 1]
      default:
        break
      }
    }
  }
}

// MARK: - Manage points

extension GameController {
  func tallyPoints() {
    totalPoints += level.points - level.costIncurred
  }
}
