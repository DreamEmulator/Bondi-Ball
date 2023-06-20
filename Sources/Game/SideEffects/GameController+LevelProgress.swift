//
//  GameController+LevelProgress.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/04/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

// MARK: - Manage level progress

extension GameController {
  func goToNextLevel() {
    let currentLevelIndex = LevelCollection.levels.firstIndex(where: { level in
      level.id == App.shared.game.level.id
    })!

    guard currentLevelIndex + 1 < LevelCollection.levels.count else {
      level = LevelCollection.levels.first!
      print("😃 We need more levels!")
      return
    }

    level = LevelCollection.levels[currentLevelIndex + 1]
  }

  func retryLevel() {
    totalPoints += level.costIncurred
    level.costIncurred = 0
    App.shared.game.state.start()
  }
}

// MARK: Subscription - Level Progress

extension GameController {
  func subscribeLevelProgress(state: GameState) {
    switch state {
    case .Missed:
      self.checkIfFailed()
    case .DraggingBall:
      self.checkIfFailed()
    case .Scored:
      self.hold {
        App.shared.game.state.levelUp()
      }
    case .LevelingUp:
      self.goToNextLevel()
    case .Failed:
      self.retryLevel()
    default:
      break
    }
  }
}
