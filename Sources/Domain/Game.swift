//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 24/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

// MARK: - The statemachine setup

typealias StateSubscription = (_ state: GameState) -> Void
typealias StateSubscriptions = [StateSubscription]

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

  func subscribe(_ sub: @escaping StateSubscription) {
    stateSubscriptions.append(sub)
  }
}

extension GameStateMachine {
  func start() {
    state = .Playing
  }

  func score() {
    state = .Scored
  }

  func levelUp() {
    state = .LevelingUp
  }
}
