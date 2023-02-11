//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

class GameController: StateSubscriber {
  // MARK: - Properties

  private(set) var totalPoints = 0
  private(set) var level: Level = LevelCollection.levels.first!
  internal var unsubscribe: AnonymousClosure?

  // MARK: - Game state

  var state = GameStateMachine()

  init() {
    subscribe()
  }

  deinit {
    if let unsubscribe {
      unsubscribe()
    }
  }
}

// MARK: Subscriptions

extension GameController {
  func subscribe() {
    unsubscribe = state.subscribe { state in
      switch state {
      case .Missed:
        App.shared.game.level.costIncurred += App.shared.game.level.wrongPocketCost
      case .Dragging:
        App.shared.game.level.costIncurred += App.shared.game.level.dragCost
      case .Scored:
        self.totalPoints += App.shared.game.level.points - App.shared.game.level.costIncurred
      case .LevelingUp:

        let currentLevelIndex = LevelCollection.levels.firstIndex(where: { level in
          level.id == App.shared.game.level.id
        })!

        guard currentLevelIndex + 1 < LevelCollection.levels.count else {
          self.level = LevelCollection.levels.first!
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
