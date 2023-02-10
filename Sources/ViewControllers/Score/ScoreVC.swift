//
//  LevellingUpController.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var pointsLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupGestures()
    subscribe()
  }
}

// MARK: - Game data

extension ScoreVC {
  func subscribe() {
    App.shared.game.state.subscribe { [weak self] state in
      switch state {
      case .Scored:
        self?.setupUI()
      default:
        break
      }
    }
  }
}

// MARK: - Gestures

extension ScoreVC {
  private func setupGestures() {
    continueButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
  }

  @objc private func continueGame() {
    App.shared.game.state.levelUp()
  }
}

// MARK: - Animations

extension ScoreVC {
  func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)

    if let score = UINib.score.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(score, pinTo: .safeArea)

      pointsLabel.text = "Total Points: \(App.shared.game.totalPoints)"
    }
  }
}
