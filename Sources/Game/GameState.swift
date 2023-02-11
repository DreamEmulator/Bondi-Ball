//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 24/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

// MARK: - The statemachine setup

enum GameState {
  case LevelingUp, RetryingLevel, Playing, Scored, Missed, Dragging, Failed
}

typealias StateSubscription = (_ state: GameState) -> Void
typealias StateSubscriptions = [StateSubscription]

protocol StateSubscriber {
  var unsubscribe: AnonymousClosure? { get set }
  func subscribe() -> Void
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

  func subscribe(_ sub: @escaping StateSubscription) -> AnonymousClosure {
    stateSubscriptions.append(sub)
    return { self.stateSubscriptions.remove(at: self.stateSubscriptions.count - 1) }
    // TODO: Return a remove so subscribers can invoke an unsubscribe
  }
}

extension GameStateMachine {
  func start() {
    switch state {
    default:
      state = .Playing
    }
  }

  func score() {
    switch state {
    case .Dragging:
      state = .Scored
    default:
      break
    }
  }

  func levelUp() {
    switch state {
    case .Scored:
      state = .LevelingUp
    default:
      break
    }
  }

  func dragging() {
    switch state {
    case .Playing, .Missed, .Dragging:
      state = .Dragging
    default:
      break
    }
  }

  func missed() {
    switch state {
    case .Dragging:
      state = .Missed
    default:
      break
    }
  }

  func failed() {
    switch state {
    case .Dragging:
      state = .Failed
    default:
      break
    }
  }
}
