//
//  BoardConfig.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 09/01/2023.
//

struct BoardConfig {
  var rows = 4
  var columns = 3
  var spring: DampedHarmonicSpring = .init(dampingRatio: 0.35, frequencyResponse: 0.95)
}
