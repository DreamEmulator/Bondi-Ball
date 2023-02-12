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
  func subscribe() {
    unsubscribe = App.shared.game.state.subscribe { [weak self] state in
      print(state)
      let progress = 1 - Float(App.shared.game.level.costIncurred) / Float(App.shared.game.level.points)

      switch state {
      case .LevelingUp:
        self?.createListOfPockets()
      case .Playing:
        self?.setupUI()
        self?.gridCollectionView.reloadData()
      case .Dragging:
        self?.costMeter.setProgress(progress, animated: true)
      case .Missed:
        self?.costMeter.setProgress(progress, animated: true)
        self?.play(sound: .missedSound)
      case .Scored:
        self?.play(sound: .scoredSound)
      case .Failed:
        print("WHY THO?")
        self?.play(sound: .failedSound)
      default:
        break
      }
    }
  }
}

// MARK: - Game management

extension GameVC {
  func updateGame(_ endpoint: PocketView?) {
    guard let endpoint else { return }
    if endpoint.isGoal {
      App.shared.game.state.score()
    } else {
      App.shared.game.state.missed()
    }
  }
}
