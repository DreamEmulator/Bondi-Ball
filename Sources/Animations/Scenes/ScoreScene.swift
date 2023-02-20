//
//  ScoreScene.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 18/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import SpriteKit
import UIKit

class ScoreScene: SKScene {
  private let mainNode: SKSpriteNode = SKSpriteNode(imageNamed: "SuccessBunny")
  override func didMove(to view: SKView) {
    backgroundColor = .clear
    mainNode.shader = createWater()
    mainNode.position = frame.center
    addChild(mainNode)
  }

  func createWater() -> SKShader {
    let uniforms: [SKUniform] = [
      SKUniform(name: "u_speed", float: 3),
      SKUniform(name: "u_strength", float: 2.5),
      SKUniform(name: "u_frequency", float: 10)
    ]
    let shader = SKShader(fileNamed: "water.fsh")
    shader.uniforms = uniforms
    return shader
  }
}
