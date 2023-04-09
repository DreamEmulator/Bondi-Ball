//
//  UIViewController+Extensions.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 20/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

// MARK: - SFX

extension UIViewController {
  func setupSpriteKit(skView: SKView, scene: SKScene) {
    // Setup SpriteKit
    view.addSubview(skView, pinTo: .viewEdges)

    skView.backgroundColor = .clear
    skView.allowsTransparency = true
    scene.backgroundColor = .clear

    NSLayoutConstraint.activate([
      skView.topAnchor.constraint(equalTo: view.topAnchor),
      skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    skView.presentScene(scene)

    // Remove skview to save resources
    var unsubscribe: AnonymousClosure? = nil
    unsubscribe = App.shared.game.state.subscribe("Sprite Kit 🏃‍♂️") { state in
      switch state {
      case .LevelingUp, .RetryingLevel:
        skView.removeFromSuperview()
        unsubscribe?()
      default:
        break
      }
    }
  }
}
