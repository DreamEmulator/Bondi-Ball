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
    modalPresentationStyle = .overFullScreen
    navigationItem.setHidesBackButton(true, animated: true)
    presentAnimation()
    setupGestures()
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
  func presentAnimation() {
    pointsLabel.text = "Total Points: \(App.shared.game.totalPoints)"
  }
}
