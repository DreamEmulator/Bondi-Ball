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
  func setupSFX() {
    let scene = traitCollection.userInterfaceStyle == .dark ? LinesScene(size: view.frame.size) : MagicParticlesScene(size: view.frame.size)
    setupSpriteKit(skView: skView, scene: scene)
  }
}
