//
//  MagicParticles.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 08/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import SpriteKit
import UIKit

class MagicParticlesScene: SKScene {
  let magicParticles = SKEmitterNode(fileNamed: "MagicParticles")

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    setupUI()
  }

  func setupUI() {
    guard let magicParticles else { return }
    addChild(magicParticles)
    applyCurrentSize()
  }

  override var size: CGSize { didSet { applyCurrentSize() } }

  private func applyCurrentSize() {
    magicParticles?.position = frame.center
    magicParticles?.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
  }
}
