//
//  LevellingUpController.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/01/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import MetalKit
import SpriteKit
import UIKit

class ScoreVC: UIViewController, StateSubscriber {
  internal var unsubscribe: AnonymousClosure?

  @IBOutlet var skView: SKView!
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var pointsLabel: UILabel!

  internal var scene = SKScene()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    subscribe()
    setupGestures()
  }

  deinit {
    unsubscribe?()
  }
}

// MARK: - Game data

extension ScoreVC {
  func subscribe() {
    unsubscribe = App.shared.game.state.subscribe("Score View Controller 🥅") { [weak self] state in
      if let self {
        switch state {
        case .Playing:
          self.scene.isPaused = true
        case .Scored:
          self.updateUI()
        default:
          break
        }
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
    App.shared.game.state.start()
  }
}

// MARK: - UI

extension ScoreVC {
  func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)

    if let score = UINib.score.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(score, pinTo: .safeArea)
    }
    updateUI()
  }

  func updateUI() {
    pointsLabel.text = "Punten: \(App.shared.game.totalPoints)"
  }
}
