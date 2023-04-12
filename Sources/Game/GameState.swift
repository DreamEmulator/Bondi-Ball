  //
  //  Game.swift
  //  Bondi Ball
  //
  //  Created by Sebastiaan Hols on 24/01/2023.
  //  Copyright © 2023 Dream Emulator. All rights reserved.
  //

  // MARK: - The statemachine setup

enum GameState {
  case LevelingUp, RetryingLevel, Playing, Scored, Missed, TouchBall, DraggingBall, FlickedBall, Failed
}

typealias StateSubscription = (_ state: GameState) -> Void
typealias StateSubscriptions = [StateSubscription]

protocol StateSubscriber {
  var unsubscribe: AnonymousClosure? { get set }
  func subscribe() -> Void
}

class GameStateMachine {
  
  init(){
    state = .Playing
  }
  
  private var state: GameState? { didSet {
    guard let state else {
      return
    }
    stateDidChange(state)
    print(state)
  }}
  
  private func stateDidChange(_ state: GameState) {
    stateSubscriptions.forEach { callBack in
      callBack(state)
    }
  }
  
  private var stateSubscriptions: StateSubscriptions = .init()
  
  func subscribe(_ subscriber: String, _ sub: @escaping StateSubscription) -> AnonymousClosure {
    stateSubscriptions.append(sub)
    print("🤝 Subscribed \(subscriber), sub-count: \(self.stateSubscriptions.count)")
    return {
      print("👋 Unsubscribed \(subscriber), sub-count: \(self.stateSubscriptions.count)")
      self.stateSubscriptions.remove(at: self.stateSubscriptions.count - 1)
    }
  }
}

extension GameStateMachine {
  func start() {
    switch state {
      case .LevelingUp, .RetryingLevel:
        state = .Playing
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
  
  func touchingBall() {
    switch state {
      case .Playing, .Missed, .TouchBall, .DraggingBall, .FlickedBall:
        state = .TouchBall
      default:
        break
    }
  }
  
  func dragging() {
    switch state {
      case .Playing, .Missed, .TouchBall, .DraggingBall:
        state = .DraggingBall
      default:
        break
    }
  }
  
  func flickedBall() {
    switch state {
      case .DraggingBall:
        state = .FlickedBall
      default:
        break
    }
  }
  
  func score() {
    switch state {
      case .FlickedBall:
        state = .Scored
      default:
        break
    }
  }
  
  func missed() {
    switch state {
      case .FlickedBall:
        state = .Missed
      default:
        break
    }
  }
  
  func failed() {
    switch state {
      case .FlickedBall, .DraggingBall:
        state = .Failed
      default:
        break
    }
  }
}
