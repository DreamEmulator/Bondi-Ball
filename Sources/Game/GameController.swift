//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

enum GameState {
  case LevelingUp, RetryingLevel, startPlaying(level: Level), Scored, Missed, Dragging
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
      stateDidChange(.startPlaying(level: level))
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
