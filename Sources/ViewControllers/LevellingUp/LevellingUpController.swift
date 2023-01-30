//
//  LevellingUpController.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

class LevellingUpController: UIViewController {
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var pointsLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.setHidesBackButton(true, animated: true)
    setupUI(totalPoints: App.shared.game.totalPoints)
    setupGestures()
    subscribe()
  }
}

// MARK: - Game data

extension LevellingUpController {
  func subscribe() {
    App.shared.game.state.subscribe { [weak self] state in
      switch state {
      case .Scored:
        self?.setupUI(totalPoints: App.shared.game.totalPoints)
      default:
        break
      }
    }
  }
}

// MARK: - Gestures

extension LevellingUpController {
  private func setupGestures() {
    continueButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
  }

  @objc private func continueGame() {
    App.shared.game.state.levelUp()
  }
}

// MARK: - Animations

extension LevellingUpController {
  func setupUI(totalPoints: Int) {
    pointsLabel.text = "Total Points: \(totalPoints)"
  }
}
