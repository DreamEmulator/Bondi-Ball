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
    unsubscribe = App.shared.game.state.subscribe { [weak self] state in
      switch state {
      case .Scored:
        self?.updateUI()
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
      setupSpriteKit()
    }
    updateUI()
  }

  func updateUI() {
    pointsLabel.text = "Punten: \(App.shared.game.totalPoints)"
  }
}

// MARK: - Animations

extension ScoreVC {
  func setupSpriteKit() {
    // Setup SpriteKit

    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.scene?.backgroundColor = .clear
    skView.scene?.view?.frame = view.frame
    skView.backgroundColor = .clear
    skView.allowsTransparency = true

    NSLayoutConstraint.activate([
      skView.topAnchor.constraint(equalTo: view.topAnchor),
      skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    skView.presentScene(ScoreScene(size: view.frame.size))
  }
}
