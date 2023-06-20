//
//  GameController+LevelProgress.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/04/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

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

// MARK: Subscription - Manage points

extension GameController {
  func subscribeGamePoints(state: GameState) {
    switch state {
    case .Missed:
      self.deductPointsForMissing()
    case .DraggingBall:
      self.deductPointsForDragging()
    case .Scored:
      self.addPointsForScoring()
    default:
      break
    }
  }
}
