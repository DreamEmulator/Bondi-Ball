//
//  ScoreScene.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 18/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import SpriteKit
import UIKit

class BackgroundScene: SKScene {
  private var shaderFile: String
  private var shaderFrame: CGRect
  
  init(shaderFile: String, shaderFrame: CGRect) {
    self.shaderFile = shaderFile
    self.shaderFrame = shaderFrame
    super.init(size: shaderFrame.size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let mainNode: SKSpriteNode = .init(imageNamed: "SuccessBunny")
  override func didMove(to view: SKView) {
    backgroundColor = .clear
    
    let spriteSize = vector_float2(Float(shaderFrame.size.width),
                                   Float(shaderFrame.size.height))
    
    let uniforms: [SKUniform] = [
      SKUniform(name: "u_speed", float: 3),
      SKUniform(name: "u_strength", float: 2.5),
      SKUniform(name: "u_frequency", float: 10),
      SKUniform(name: "u_sprite_size", vectorFloat2: spriteSize)
    ]

    mainNode.shader = SKShader(fileNamed: shaderFile)
    mainNode.shader!.uniforms = uniforms
    mainNode.position = shaderFrame.center
    mainNode.size = shaderFrame.size
    addChild(mainNode)
  }
}
