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
    unsubscribe = state.subscribe { [weak self] state in
      switch state {
      case .Missed:
        self?.deductPointsForMissing()
        self?.checkIfFailed()
      case .DraggingBall:
        self?.deductPointsForDragging()
        self?.checkIfFailed()
      case .Scored:
        self?.addPointsForScoring()
      case .LevelingUp:
        self?.goToNextLevel()
      case .Failed:
        self?.retryLevel()
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

  func checkIfFailed() {
    if App.shared.game.level.points - App.shared.game.level.costIncurred < 0 {
      App.shared.game.state.failed()
    }
  }

  func deductPointsForMissing() {
    App.shared.game.level.costIncurred += App.shared.game.level.wrongPocketCost
  }

  func deductPointsForDragging() {
    App.shared.game.level.costIncurred += App.shared.game.level.dragCost
  }

  func addPointsForScoring() {
    totalPoints += App.shared.game.level.points - App.shared.game.level.costIncurred
  }
}

// MARK: - Manage level progress

extension GameController {
  func goToNextLevel() {
    let currentLevelIndex = LevelCollection.levels.firstIndex(where: { level in
      level.id == App.shared.game.level.id
    })!

    guard currentLevelIndex + 1 < LevelCollection.levels.count else {
      self.level = LevelCollection.levels.first!
      print("😃 We need more levels!")
      return
    }

    self.level = LevelCollection.levels[currentLevelIndex + 1]
  }

  func retryLevel(){
    self.totalPoints += self.level.costIncurred
    self.level.costIncurred = 0
    App.shared.game.state.start()
  }
}
