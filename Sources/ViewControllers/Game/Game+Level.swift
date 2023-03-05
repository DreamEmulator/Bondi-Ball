//
//  Game+Logic.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 12/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

// MARK: - Subscribe

extension GameVC {
  func subscribeLevel() {
    unsubscribeLevel = App.shared.game.state.subscribe { [weak self] state in
      print(state)
      if let self {
        let progress = 1 - Float(App.shared.game.level.costIncurred) / Float(App.shared.game.level.points)
        switch state {
        case .LevelingUp:
          break
        case .Playing:
          App.shared.game.state.start()
        case .DraggingBall:
          self.costMeter.setProgress(progress, animated: true)
        case .Missed:
          self.costMeter.setProgress(progress, animated: true)
        case .RetryingLevel:
          self.scene.isPaused = true
          self.unsubscribe?()
        default:
          break
        }
      }
    }
  }
}

// MARK: - Game management

extension GameVC {
  func updateGame(_ endpoint: PocketView?) {
    guard let viewData = pocketViewData.first(where: { $0.id.row == endpoint?.tag }) else {
      return
    }
    guard !viewData.isStartPocket else { return }
    if viewData.isGoal {
      App.shared.game.state.score()
    } else {
      App.shared.game.state.missed()
    }
  }
}
