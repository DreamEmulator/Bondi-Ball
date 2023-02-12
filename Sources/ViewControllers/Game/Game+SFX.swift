//
//  Game+SFX.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 12/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import SpriteKit

// MARK: - Particle effects

extension GameVC {
  func setupParticles() {
    skView.removeFromSuperview()
    skView = SKView(frame: view.frame)
    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.isUserInteractionEnabled = false
    skView.scene?.view?.isUserInteractionEnabled = false
    magicParticles?.position = skView.center

    view.backgroundColor = .clear
    view.addSubview(skView)

    NSLayoutConstraint.activate([
      skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      skView.topAnchor.constraint(equalTo: view.topAnchor),
      skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    setupSceneView()
    setupScene()
  }

  func setupSceneView() {
    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.scene?.backgroundColor = .clear
    skView.scene?.view?.frame = view.frame
    skView.backgroundColor = .clear
    skView.allowsTransparency = true
  }

  func setupScene() {
    let scene = MagicParticlesScene(size: view.frame.size)
    scene.scaleMode = .aspectFill
    scene.backgroundColor = .clear
    skView.presentScene(scene)
  }
}
