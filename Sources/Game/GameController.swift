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
    print(config.columns)
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

// MARK: - The statemachine setup

typealias StateSubscription = (_ state: GameState) -> Void
typealias StateSubscriptions = [StateSubscription]

extension GameStateMachine {
  // MARK: - Methods to alter the state

  func start(level: Level) {
    switch state {
    case .LevelingUp, .RetryingLevel, .Dragging:
      break
    default:
      state = .Playing(level: level)
    }
  }

  func score() {
    switch state {
    case .Playing:
      App.shared.game.tallyPoints()
      state = .Scored
    // Calculate new total points
    // Switch to Leveling up
    default: break
    }
  }

  func levelUp() {
    switch state {
    case .Scored:
      state = .LevelingUp
      // TODO: https://github.com/DreamEmulator/Fidget/issues/14
      guard let currentLevelIndex = LevelCollection.levels.firstIndex(where: { level in
        level.id == App.shared.game.level.id
      }) else { fatalError("Can't find current level") }
      if currentLevelIndex + 1 < LevelCollection.levels.count {
        let nextLevel = LevelCollection.levels[currentLevelIndex + 1]
        App.shared.game.setLevel(nextLevel)
        state = .Playing(level: nextLevel)
      } else {
        print("😃 We need more levels!")
        App.shared.game.setLevel(LevelCollection.levels.first!)
        state = .Playing(level: LevelCollection.levels.first!)
      }

    default: break
    }
  }
}

class GameStateMachine {
  private var state: GameState? { didSet {
    guard let state else {
      return
    }
    stateDidChange(state)
  }}

  private func stateDidChange(_ state: GameState) {
    stateSubscriptions.forEach { callBack in
      callBack(state)
    }
  }

  private var stateSubscriptions: StateSubscriptions = .init()

  // MARK: - Allow others to subscribe to state updates

  func subscribe(_ sub: @escaping StateSubscription) {
    stateSubscriptions.append(sub)
  }
}
