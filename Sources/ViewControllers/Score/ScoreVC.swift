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

  @IBOutlet var spriteKitView: SKView!
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

    spriteKitView.translatesAutoresizingMaskIntoConstraints = false
    spriteKitView.scene?.backgroundColor = .clear
    spriteKitView.scene?.view?.frame = view.frame
    spriteKitView.backgroundColor = .clear
    spriteKitView.allowsTransparency = true

    NSLayoutConstraint.activate([
      spriteKitView.topAnchor.constraint(equalTo: view.topAnchor),
      spriteKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      spriteKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      spriteKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    spriteKitView.presentScene(ScoreScene(size: view.frame.size))
  }
}
