//
//  ScoreScene.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 18/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import SpriteKit
import UIKit

class PurpleLightsScene: SKScene {
  private let mainNode: SKSpriteNode = SKSpriteNode(imageNamed: "SuccessBunny")
  override func didMove(to view: SKView) {
    backgroundColor = .clear
    let spriteSize = vector_float2(Float(frame.size.width),
                                   Float(frame.size.height))
    mainNode.shader = SKShader(fileNamed: "purple_lights.fsh")
    mainNode.shader!.uniforms.append(SKUniform(name: "u_sprite_size", vectorFloat2: spriteSize))
    mainNode.position = frame.center
    mainNode.size = frame.size
    addChild(mainNode)
  }
}
