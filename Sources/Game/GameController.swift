//
//  Game.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 29/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//
import Foundation
import AVFoundation

class GameController: StateSubscriber {
  var soundtrackPlayer: AVPlayer? = nil

  // MARK: - Properties
  var totalPoints = 0
  var level: Level = LevelCollection.levels.first!
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
      unsubscribe = state.subscribe("GameController 👾") { [weak self] state in
      if let self {
        self.subscribeLevelProgress(state: state)
        self.subscribeGamePoints(state: state)
        self.subscribeSoundtrackProgression(state: state)
      }
    }
  }

  func hold(for time: TimeInterval = 1.0, _ completion: @escaping AnonymousClosure) {
    Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
      completion()
    }
  }
}
